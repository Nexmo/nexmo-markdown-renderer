class UseCase
  include ActiveModel::Model
  attr_accessor :title, :description, :external_link, :products, :document_path, :languages, :root

  def body
    File.read(document_path)
  end

  def path
    return external_link if external_link
    path = document_path.relative_path_from(UseCase.origin).sub("#{I18n.locale}/", '')
    "/use-cases/#{path}".gsub('.md', '')
  end

  def subtitle
    normalized_products = products.map do |product|
      normalise_product_title(product)
    end

    normalized_products.sort.to_sentence
  end

  def normalise_product_title(product)
    return 'SMS' if product == 'messaging/sms'
    return 'Voice' if product == 'voice/voice-api'
    return 'Number Insight' if product == 'number-insight'
    return 'Messages' if product == 'messages'
    return 'Dispatch' if product == 'dispatch'
    return 'Client SDK' if product == 'client-sdk'
    return 'Subaccounts' if product == 'account/subaccounts'
    product.camelcase
  end

  def self.by_product(product, use_cases = [])
    use_cases = all if use_cases.empty?
    use_cases.select do |use_case|
      use_case.products.include? product
    end
  end

  def self.by_language(language, use_cases = [])
    language = language.downcase
    use_cases = all if use_cases.empty?

    use_cases.select do |use_case|
      use_case.languages.map(&:downcase).include? language
    end
  end

  def self.origin
    Pathname.new("#{ENV['DOCS_BASE_PATH']}/_use_cases")
  end

  def self.all
    files.map do |document_path|
      document_path = Pathname.new(document_path)
      document = File.read(document_path)
      frontmatter = YAML.safe_load(document)

      UseCase.new({
        title: frontmatter['title'],
        description: frontmatter['description'],
        external_link: frontmatter['external_link'],
        products: frontmatter['products'].split(',').map(&:strip),
        languages: frontmatter['languages'] || [],
        document_path: document_path,
        root: '_use_cases',
      })
    end
  end

  private

  private_class_method def self.files
    Dir.glob("#{origin}/**/*.md")
  end
end
