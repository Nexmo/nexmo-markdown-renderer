module Nexmo
  module Markdown
    module CodeSnippetRenderer
      class Base
        def self.inherited(base)
          base.extend ActionView::Helpers::TranslationHelper
          base.instance_variable_set :@virtual_path, "services.#{base.name.underscore.tr('/', '.')}"
        end

        def self.replace_placeholders(input, options)
          input
        end
      end
    end
  end
end
