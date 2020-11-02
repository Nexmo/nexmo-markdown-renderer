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
  end
end