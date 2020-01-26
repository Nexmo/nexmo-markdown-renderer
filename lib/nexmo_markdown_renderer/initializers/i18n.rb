I18n.load_path << Dir[File.expand_path(__dir__, "./config/locales") + "/*.yml"]
I18n.default_locale = :en
