module Nexmo
  module Markdown
    class CodeFilter < Banzai::Filter
      include Nexmo::Markdown::Concerns::PrismCodeSnippet

      def call(input)
        input.gsub(/(?!.*snippet)```code(.+?)```/m) do |_s|
          config = YAML.safe_load($1)

          if config['config']
            configs = YAML.load_file("#{Nexmo::Markdown::Config.docs_base_path}/config/code_examples.yml")
            config = config['config'].split('.').inject(configs) { |h, k| h[k] }
          end

          code = File.read("#{Nexmo::Markdown::Config.docs_base_path}/#{config['source']}")
          language = File.extname("#{Nexmo::Markdown::Config.docs_base_path}/#{config['source']}")[1..-1]
          lexer = language_to_lexer(language)

          total_lines = code.lines.count

          # Minus one since lines are not zero-indexed
          from_line = (config['from_line'] || 1) - 1
          to_line = (config['to_line'] || total_lines) - 1

          code = code.lines[from_line..to_line].join
          code.unindent! if config['unindent']

          highlighted_source = highlight(code, lexer)

          code_snippet_body(lexer, highlighted_source)
        end
      end

      private

      def highlight(source, lexer)
        formatter = Rouge::Formatters::HTML.new
        formatter.format(lexer.lex(source))
      end

      def language_to_lexer_name(language)
        if language_configuration[language]
          language_configuration[language]['lexer']
        else
          language
        end
      end

      def language_to_lexer(language)
        language = language_to_lexer_name(language)
        return Rouge::Lexers::PHP.new({ start_inline: true }) if language == 'php'

        Rouge::Lexer.find(language.downcase) || Rouge::Lexer.find('text')
      end

      def language_configuration
        @language_configuration ||= YAML.load_file("#{GEM_ROOT}/config/code_languages.yml")
      end
    end

  end
end
