module Nexmo
  module Markdown
    class Config
      def self.docs_base_path
        @docs_base_path ||= ENV.fetch('DOCS_BASE_PATH', '.')
      end
    end
  end
end
