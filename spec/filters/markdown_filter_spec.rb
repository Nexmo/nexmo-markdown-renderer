require 'spec_helper'

RSpec.describe Nexmo::Markdown::MarkdownFilter do
  describe '#call' do
    subject { described_class.call(input) }

    context 'converting images' do
      let(:input) do
        "![Markdown Image Alt Text](/images/example.png 'Markdown Image Title')"
      end

      it 'converts markdown images into image tags' do
        html = Capybara::Node::Simple.new(subject)

        expect(html).to have_css('figcaption', text: 'Markdown Image Alt Text')
        expect(html).to have_css('img[src="/images/example.png"][alt="Markdown Image Alt Text"]')
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
        expect(subject).to include('main-code Vlt-prism--dark')
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
        expect(subject).to include('main-code Vlt-prism--dark')
      end
    end

    context 'converting code blocks' do
      let(:input) do
        <<~HEREDOC
          ```
          nexmo link:app YOUR_VONAGE_NUMBER APPLICATION_ID
          ```
        HEREDOC
      end

      it 'strips the newline at the end' do
        expect(subject).to eq("<pre class=\"main-code Vlt-prism--dark language-plaintext\" data-lang=\"plaintext\" data-section=\"code\" data-block=\"\"><code>nexmo link:app YOUR_VONAGE_NUMBER APPLICATION_ID</code></pre>\n")
      end
    end
  end
end
