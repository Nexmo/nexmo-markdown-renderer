require 'spec_helper'

RSpec.describe Nexmo::Markdown::TabFilter do
  before do
    allow(File).to receive(:exist?).and_call_original
    allow(Nexmo::Markdown::Config).to receive(:docs_base_path).and_return('.')
  end

  context 'when no config is provided' do
    it 'raises an exception' do
      input = <<~HEREDOC
        ```tabbed_examples
        ```
      HEREDOC

      expect do
        described_class.new.call(input)
      end.to raise_error('Source or tabs must be present in this tabbed_example config')
    end
  end

  context 'when an invalid config is provided' do
    it 'raises an exception' do
      input = <<~HEREDOC
        ```tabbed_examples
        foo: 'bar'
        ```
      HEREDOC

      expect do
        described_class.new.call(input)
      end.to raise_error('Source or tabs must be present in this tabbed_example config')
    end
  end

  it 'when content is not a tab filter, nothing happens' do
    input = 'test content is ignored'
    actual = described_class.new.call(input)
    expect(actual).to eq(input)
  end

  context 'when input is a directory' do
    let(:path) { 'path/to/a/directory' }

    it 'raises an exception if tabbed parameter is not set to true' do
      expect(File).to receive(:directory?).with("#{path}").and_return(true)
      expect(File).to receive(:read).with("#{path}/.config.yml").and_return(config_tabbed_false)
      input = <<~HEREDOC
        ```tabbed_folder
        source: #{path}
        ```
      HEREDOC
      expect do
        described_class.new.call(input)
      end.to raise_error('Tabbed must be set to true in the folder config YAML file')
    end

    it 'raises an exception if source path is not a directory' do
      expect(File).to receive(:directory?).with("#{path}").and_return(false)
      input = <<~HEREDOC
        ```tabbed_folder
        source: #{path}
        ```
      HEREDOC
      expect do
        described_class.new.call(input)
      end.to raise_error("#{path} is not a directory")
    end

    it 'raises an error if there are no files in input directory' do
      expect(File).to receive(:directory?).with("#{path}").and_return(true)
      expect(File).to receive(:read).with("#{path}/.config.yml").and_return(config_tabbed_true)
      expect(Dir).to receive(:glob).with("#{path}/*.md").and_return([])
      input = <<~HEREDOC
        ```tabbed_folder
        source: #{path}
        ```
      HEREDOC
      expect do
        described_class.new.call(input)
      end.to raise_error("Empty content_from_source file list in #{path}/*.md")
    end

    it 'renders content with one markdown file in input' do
      expect(File).to receive(:directory?).with("#{path}").and_return(true)
      expect(File).to receive(:read).with("#{path}/.config.yml").and_return(config_tabbed_true)
      expect(Dir).to receive(:glob).with("#{path}/*.md").and_return(["#{path}/javascript.md"])
      mock_content('javascript', first_sample_markdown)
      expect(SecureRandom).to receive(:hex).once.and_return('ID123456')

      input = <<~HEREDOC
        ```tabbed_folder
        source: #{path}
        ```
      HEREDOC
      expect(described_class.new.call(input)).to match_snapshot('tab_filter/one_file')
    end

    it 'renders content with two markdown files in input' do
      expect(File).to receive(:directory?).with("#{path}").and_return(true)
      expect(File).to receive(:read).with("#{path}/.config.yml").and_return(config_tabbed_true)
      expect(Dir).to receive(:glob).with("#{path}/*.md").and_return(["#{path}/javascript.md", "#{path}/android.md"])
      mock_content('javascript', first_sample_markdown)
      mock_content('android', second_sample_markdown)
      expect(SecureRandom).to receive(:hex).twice.and_return('ID123456')

      input = <<~HEREDOC
        ```tabbed_folder
        source: #{path}
        ```
      HEREDOC
      expect(described_class.new.call(input)).to match_snapshot('tab_filter/two_files')
    end

    it 'renders content with three markdown files in input' do
      expect(File).to receive(:directory?).with("#{path}").and_return(true)
      expect(File).to receive(:read).with("#{path}/.config.yml").and_return(config_tabbed_true)
      expect(Dir).to receive(:glob).with("#{path}/*.md").and_return(["#{path}/javascript.md", "#{path}/android.md", "#{path}/ios.md"])
      mock_content('javascript', first_sample_markdown)
      mock_content('android', second_sample_markdown)
      mock_content('ios', third_sample_markdown)
      expect(SecureRandom).to receive(:hex).exactly(3).times.and_return('ID123456')

      input = <<~HEREDOC
        ```tabbed_folder
        source: path/to/a/directory
        ```
      HEREDOC
      expect(described_class.new.call(input)).to match_snapshot('tab_filter/three_files')
    end
  end

  def config_tabbed_false
    <<~HEREDOC
      ---
      tabbed: false
    HEREDOC
  end

  def config_tabbed_true
    <<~HEREDOC
      ---
      tabbed: true
    HEREDOC
  end

  def first_sample_markdown
    <<~HEREDOC
      ---
      title: First Sample Markdown
      language: javascript
      ---
       ## Heading
       Sample content
    HEREDOC
  end

  def second_sample_markdown
    <<~HEREDOC
      ---
      title: Second Sample Markdown
      language: javascript
      ---
       ## Heading
       Sample content
    HEREDOC
  end

  def third_sample_markdown
    <<~HEREDOC
      ---
      title: Third Sample Markdown
      language: javascript
      ---
       ## Heading
       Sample content
    HEREDOC
  end

  def mock_content(name, content)
    expect(File).to receive(:exist?).with("path/to/a/directory/#{name}.md").and_return(true)
    expect(File).to receive(:read).with("path/to/a/directory/#{name}.md").and_return(content)
  end
end
