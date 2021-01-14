module Nexmo
  module Markdown
    class CodeSnippet
      include ActiveModel::Model
      attr_accessor :title, :product, :category, :navigation_weight, :document_path, :url

      def self.by_product(product)
        all.select do |block|
          block.product == product
        end
      end

      def self.all
        blocks = files.map do |document_path|
          document = File.read(document_path)
          product = extract_product(document_path)

          frontmatter = YAML.safe_load(document)

          Nexmo::Markdown::CodeSnippet.new({
            title: frontmatter['title'],
            navigation_weight: frontmatter['navigation_weight'] || 999,
            product: product,
            document_path: document_path,
            category: extract_category(document_path),
            url: generate_url(document_path),
          })
        end

        blocks.sort_by(&:navigation_weight)
      end

      def self.generate_url(path)
        '/' + path.gsub(%r{#{origin}/\w{2}/}, '').gsub('.md', '')
      end

      def self.extract_product(path)
        # Remove the prefix
        path = path.gsub!(%r{#{origin}/\w{2}/}, '')

        # Each file is in the form code-snippets/<title>.md, so let's remove everything after code-snippets
        path = path.gsub(%r{/code-snippets/.*}, '')

        path
      end

      def self.extract_category(path)
        # Remove the prefix
        path = path.gsub(%r{#{origin}/\w{2}/}, '')

        # Each file is in the form code-snippets/<title>.md, so let's capture everything after code-snippets
        path = path.gsub(%r{.*/code-snippets/(.*)$}, '\1')

        parts = path.split('/')
        parts = parts[0...-1]

        return nil if parts.empty?

        parts.join('/').tr('-', ' ').humanize
      end

      def self.files
        root = "#{origin}/#{::I18n.default_locale}"
        Dir.glob("#{root}/**/code-snippets/**/*.md").map do |path|
          DocFinder.find(root: origin, document: path.gsub(root, ''), language: ::I18n.locale).path
        end
      end

      def self.origin
        "#{Nexmo::Markdown::Config.docs_base_path}/_documentation"
      end
    end

  end
end
