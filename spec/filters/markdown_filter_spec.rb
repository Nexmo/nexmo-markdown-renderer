require 'spec_helper'

RSpec.describe Nexmo::Markdown::MarkdownFilter do
  describe '#call' do
    subject { described_class.call(input) }

    context 'converting images' do
      let(:input) do
        "![Markdown Image Alt Text](/images/example.png 'Markdown Image Title')"
      end

      it 'converts markdown images into image tags' do
        expect(subject).to eq('<p><figure><img src="/images/example.png" alt="Markdown Image Alt Text"></figure></p>')
      end
    end

    context 'converting tabbed content blocks' do
      let(:input) do
        <<~HEREDOC
          ```tabbed_content
          source: '_tutorials/application/create-voice.md
          ```
        HEREDOC
      end

      it 'converts markdown tabbed content with a copy to clipboard function' do
        expect(subject).to include('<div class="copy-wrapper">')
      end
    end

    context 'converting tabbed examples blocks' do
      let(:input) do
        <<~HEREDOC
          ```tabbed_examples
          source: '_tutorials/application/create-voice.md
          ```
        HEREDOC
      end

      it 'converts markdown tabbed content with a copy to clipboard function' do
        expect(subject).to include('<div class="copy-wrapper">')
      end
    end
  end
end