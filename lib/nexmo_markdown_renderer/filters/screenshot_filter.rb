module Nexmo
  module Markdown
    class ScreenshotFilter < Banzai::Filter
      def call(input)
        input.gsub(/```screenshot(.+?)```/m) do |_s|
          config = YAML.safe_load($1)
          if config['image'] && File.file?("#{Nexmo::Markdown::Config.docs_base_path}/#{config['image']}")
            "![Screenshot](#{config['image'].gsub('public', '')})"
          else
            <<~HEREDOC
              ## Missing image
              To fix this run:
              ```
              $ rake screenshots:update
              ```
            HEREDOC
          end
        end
      end
    end
  end
end
