require 'i18n'

I18n.load_path += Dir[
  File.join(File.dirname(__FILE__), '../config/locales'.freeze, '*.yml'.freeze)
]
I18n.default_locale = :en
