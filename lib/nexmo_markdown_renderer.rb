# frozen_string_literal: true

require 'banzai'
require 'octicons_helper'
require 'nokogiri'
require 'open-uri'
require 'active_model'
require 'i18n'
require './lib/nexmo_markdown_renderer/initializers/redcarpet'
require './lib/nexmo_markdown_renderer/initializers/i18n'
require './lib/nexmo_markdown_renderer/config/core_ext/string'
Dir[File.join('./lib/nexmo_markdown_renderer/services/code_snippet_renderer', '*.rb')].each { |file| require file }
Dir[File.join('./lib/nexmo_markdown_renderer/models', '*.rb')].each { |file| require file }
Dir[File.join('./lib/nexmo_markdown_renderer/filters', '*.rb')].each { |file| require file }
Dir[File.join('./lib/nexmo_markdown_renderer/filters/i18n', '*.rb')].each { |file| require file }
require_relative './nexmo_markdown_renderer/markdown_renderer'
