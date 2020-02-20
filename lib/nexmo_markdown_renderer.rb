# frozen_string_literal: true
GEM_ROOT = File.expand_path("../..", __FILE__)
require 'banzai'
require 'octicons_helper'
require 'nokogiri'
require 'open-uri'
require 'active_model'
require 'i18n'
require_relative 'nexmo_markdown_renderer/initializers/redcarpet'
require_relative 'nexmo_markdown_renderer/initializers/i18n'
require_relative 'nexmo_markdown_renderer/core_ext/string'
require_relative 'nexmo_markdown_renderer/services/code_snippet_renderer/base'
require_relative 'nexmo_markdown_renderer/services/code_snippet_renderer/android'
require_relative 'nexmo_markdown_renderer/services/code_snippet_renderer/curl'
require_relative 'nexmo_markdown_renderer/services/code_snippet_renderer/dotnet'
require_relative 'nexmo_markdown_renderer/services/code_snippet_renderer/java'
require_relative 'nexmo_markdown_renderer/services/code_snippet_renderer/javascript'
require_relative 'nexmo_markdown_renderer/services/code_snippet_renderer/kotlin'
require_relative 'nexmo_markdown_renderer/services/code_snippet_renderer/objective_c'
require_relative 'nexmo_markdown_renderer/services/code_snippet_renderer/php'
require_relative 'nexmo_markdown_renderer/services/code_snippet_renderer/python'
require_relative 'nexmo_markdown_renderer/services/code_snippet_renderer/ruby'
require_relative 'nexmo_markdown_renderer/services/code_snippet_renderer/swift'
Dir[File.join(__dir__, 'nexmo_markdown_renderer/services', '*.rb')].each { |file| require_relative file }
Dir[File.join(__dir__, 'nexmo_markdown_renderer/models', '*.rb')].each { |file| require_relative file }
Dir[File.join(__dir__, 'nexmo_markdown_renderer/filters', '*.rb')].each { |file| require_relative file }
Dir[File.join(__dir__, 'nexmo_markdown_renderer/filters/i18n', '*.rb')].each { |file| require_relative file }
require_relative 'nexmo_markdown_renderer/markdown_renderer'
