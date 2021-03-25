module Nexmo
  module Markdown
    module Concerns
      module PrismCodeSnippet

        def code_snippet_body(lexer, body, options = {})
          <<~HEREDOC
            <pre class="#{prism_css_classes(lexer)}" data-lang="#{code_language_to_prism(lexer.tag)}" data-section="code" data-block="#{options[:block]}"><code>#{body.chomp}</code></pre>
          HEREDOC
        end

        def code_language_to_prism(code_language)
          code_language == 'objective_c' && 'objectivec' || code_language
        end

        def prism_css_classes(lexer)
          code_language = code_language_to_prism(lexer.tag)
          "main-code Vlt-prism--dark language-#{code_language}"
        end
      end
    end
  end
end
