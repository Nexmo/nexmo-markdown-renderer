module Nexmo
  module Markdown
    module Concerns
      module PrismCodeSnippet
        def code_snippet_body(lexer, body)
          <<~HEREDOC
            <pre class="#{prism_css_classes(lexer)}"><code>#{body}</code></pre>
          HEREDOC
        end

        def code_language_to_prism(code_language)
          code_language == 'objective_c' && 'objectivec' || code_language
        end

        def prism_css_classes(lexer)
          code_language = code_language_to_prism(lexer.tag)
          "main-code Vlt-prism--dark language-#{code_language} Vlt-prism--copy-disabled"
        end
      end
    end
  end
end
