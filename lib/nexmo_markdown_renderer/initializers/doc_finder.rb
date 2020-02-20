Nexmo::Markdown::DocFinder.configure do |config|
  config.paths << "#{ENV['DOCS_BASE_PATH']}/_documentation"
  config.paths << "#{ENV['DOCS_BASE_PATH']}/_use_cases"
  config.paths << "#{ENV['DOCS_BASE_PATH']}/_tutorials"
end
