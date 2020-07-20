module Nexmo
  module Markdown
    class Config
      def self.mounted?
        defined?(Rails) && !Rails.application.nil?
      end
    
      def self.docs_base_path
        (mounted? && Rails.application.config.docs_base_path) || '.'
      end
    
      def self.load_file(file_path)
        full_path =  "#{docs_base_path}/#{file_path}"
        File.exist?(full_path) && YAML.load_file(full_path) || YAML.load_file("./#{file_path}") 
      end
    end
  end
end