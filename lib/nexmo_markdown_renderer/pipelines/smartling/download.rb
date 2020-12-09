module Nexmo
  module Markdown
    module Pipelines
      module Smartling
        class Download < Banzai::Pipeline
          def initialize(_options = {})
            super(
              I18n::Smartling::FrontmatterFilter,
              I18n::Smartling::EscapeFilter
            )
          end
        end
      end
    end
  end
end
