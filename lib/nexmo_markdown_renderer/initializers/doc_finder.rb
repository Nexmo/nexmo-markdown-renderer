Nexmo::Markdown::DocFinder.configure do |config|
  config.paths << "#{DOCS_BASE_PATH}/_documentation"
  config.paths << "#{DOCS_BASE_PATH}/_use_cases"
  config.paths << "#{DOCS_BASE_PATH}/_tutorials"
end
