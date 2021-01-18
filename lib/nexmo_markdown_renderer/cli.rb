require "thor"
require_relative "../nexmo_markdown_renderer"
require_relative "initializers/doc_finder"
module Nexmo::Markdown
  class CLI < Thor
    desc "render FILE", "passes FILE throught the pipeline and renders it as html"
    def render(file)
      puts Nexmo::Markdown::Renderer.new.call(File.read("#{ENV['DOCS_BASE_PATH']}/#{file}")).to_s
    end
  end
end