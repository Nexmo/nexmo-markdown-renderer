module Nexmo
  module Markdown
    class ConceptListFilter < Banzai::Filter
      def call(input)
        input.gsub(/```concept_list(.+?)```/m) do |_s|
          config = YAML.safe_load($1)
    
          raise 'concept_list filter takes a YAML config' if config.nil?
          raise "concept_list filter requires 'product' or 'concepts' key" unless config['product'] || config['concepts']
    
          if config['product']
            @product = config['product']
            @concepts = Nexmo::Markdown::Concept.by_product(@product, @options[:language])
          elsif config['concepts']
            @concepts = Nexmo::Markdown::Concept.by_name(config['concepts'], @options[:language])
          end
    
          @concepts.reject!(&:ignore_in_list)
    
          return '' if @concepts.empty?
    
          erb = File.read("#{GEM_ROOT}/lib/nexmo_markdown_renderer/views/concepts/list/plain.html.erb")
          html = ERB.new(erb).result(binding)
          "FREEZESTART#{Base64.urlsafe_encode64(html)}FREEZEEND"
        end
      end
    end
    
  end
end