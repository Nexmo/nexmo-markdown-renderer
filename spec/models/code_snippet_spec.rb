require 'spec_helper'

RSpec.describe Nexmo::Markdown::CodeSnippet, type: :model do
  before do
    allow(Dir).to receive(:glob).and_call_original
  end

  describe '#extract_product' do
    before do
      allow(Nexmo::Markdown::CodeSnippet).to receive(:origin).and_return('/path/to/_documentation')
    end

    it 'extracts voice successfully' do
      snippet = "#{Nexmo::Markdown::CodeSnippet.origin}/en/voice/voice-api/code-snippets/demo.md"
      allow(Dir).to receive(:glob).and_return([snippet])

      expect(Nexmo::Markdown::CodeSnippet.extract_product(snippet)).to eq('voice/voice-api')
    end

    it 'extracts sms successfully' do
      snippet = "#{Nexmo::Markdown::CodeSnippet.origin}/en/messaging/sms/code-snippets/demo.md"
      allow(Dir).to receive(:glob).and_return([snippet])

      expect(Nexmo::Markdown::CodeSnippet.extract_product(snippet)).to eq('messaging/sms')
    end
  end

  describe '#extract_category' do
    before do
      allow(Nexmo::Markdown::CodeSnippet).to receive(:origin).and_return('/path/to/_documentation')
    end

    it 'sets no category for top level code snippets' do
      snippet = "#{Nexmo::Markdown::CodeSnippet.origin}/en/voice/voice-api/code-snippets/demo.md"
      allow(Dir).to receive(:glob).and_return([snippet])

      expect(Nexmo::Markdown::CodeSnippet.extract_category(snippet)).to eq(nil)
    end

    it 'sets the correct category for nested code snippets' do
      snippet = "#{Nexmo::Markdown::CodeSnippet.origin}/en/messaging/sms/code-snippets/sub-folder/demo.md"
      allow(Dir).to receive(:glob).and_return([snippet])

      expect(Nexmo::Markdown::CodeSnippet.extract_category(snippet)).to eq('Sub folder')
    end
  end

  describe '#all' do
    it 'returns all code snippets' do
      stub_available_blocks

      expect(Nexmo::Markdown::CodeSnippet.all).to have(4).items
    end
  end

  describe '#by_product' do
    it 'shows only sms' do
      stub_available_blocks
      expect(Nexmo::Markdown::CodeSnippet.by_product('messaging/sms')).to have(1).items
    end
    it 'shows only voice' do
      stub_available_blocks
      expect(Nexmo::Markdown::CodeSnippet.by_product('voice/voice-api')).to have(3).items
    end
  end

  describe '#files' do
    it 'has the correct glob pattern' do
      allow(Nexmo::Markdown::CodeSnippet).to receive(:origin).and_return('/path/to/_documentation')
      expect(Dir).to receive(:glob).with('/path/to/_documentation/**/code-snippets/**/*.md')
      Nexmo::Markdown::CodeSnippet.files
    end
  end

  describe '#origin' do
    it 'returns the correct origin' do
      expect(Nexmo::Markdown::CodeSnippet.origin).to eq("#{Nexmo::Markdown::Config.docs_base_path}/_documentation")
    end
  end

  describe '.instance' do
    it 'has the expected accessors' do
      stub_available_blocks

      block = Nexmo::Markdown::CodeSnippet.all.first
      expect(block.title).to eq('Example Long Title')
      expect(block.navigation_weight).to eq(1)
      expect(block.product).to eq('voice/voice-api')
      expect(block.category).to eq(nil)
      expect(block.document_path).to eq('voice/voice-api/code-snippets/example-long-title.md')
      expect(block.url).to eq('/voice/voice-api/code-snippets/example-long-title')
    end
  end
end

def stub_available_blocks
  paths = []

  i = 0
  {
    'Example Long Title' => 'voice/voice-api',
    'Short' => 'messaging/sms',
    'Demo' => 'voice/voice-api',
  }.each do |title, product|
    i += 1
    slug = title.parameterize
    path = "_documentation/en/#{product}/code-snippets/#{slug}.md"
    paths.push(path)

    allow(File).to receive(:read).with(path) .and_return(
      {
        'title' => title,
        'navigation_weight' => i,
      }.to_yaml
    )
  end

  # Add an example that has nested folders
  path = '_documentation/en/voice/voice-api/code-snippets/nested-blocks/nested-example.md'
  i += 1
  allow(File).to receive(:read).with(path) .and_return(
    {
      'title' => 'This is a nested example',
      'navigation_weight' => i,
    }.to_yaml
  )
  paths.push(path)

  allow(Nexmo::Markdown::CodeSnippet).to receive(:origin).and_return('_documentation')
  allow(Nexmo::Markdown::CodeSnippet).to receive(:files).and_return(paths)
end
