module Nexmo
  module Markdown
    class SnippetVariablesFilter < Banzai::Filter
      def call(input)
        input.gsub(/```snippet_variables(.+?)```/m) do |_s|
          config = YAML.safe_load(Regexp.last_match(1))

          raise 'No variables provided' unless config
          raise 'Must provide an array' unless config.is_a?(Array)

          output = <<~HEREDOC
            Key | Description
            -- | --
          HEREDOC
          config.each do |key|

            details = variables[key]
            raise "#{key} is not a valid snippet variable" unless details

            # We have some variables in the format TO_NUMBER.SMS etc, and we only want to render the first segment
            # This can be multiple segments e.g. UUID.MODIFY.VOICE will be rendered as UUID
            title = key.split('.').first

            output += <<~HEREDOC
              `#{title}` | #{details}
            HEREDOC
          end

          output
        end
      end

      def variables
        @variables ||= YAML.safe_load(File.read("#{Nexmo::Markdown::Config.docs_base_path}/config/code_snippet_variables.yml"))
      end
    end
  end
end
