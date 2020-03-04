require 'spec_helper'

RSpec.describe Nexmo::Markdown::RelativeLinkFilter do
  describe '.call' do
    let(:input) do
      <<~HTML
        <a href='/relative/path/1'>Relative Link 1</a>
        <a href='/relative/path/2'>Relative Link 2</a>
        <a href='https://developer.nexmo.com'>NDP</a>
      HTML
    end

    subject { described_class.new(locale: locale).call(input) }

    context 'specifying a locale' do
      let(:locale) { :en }

      it 'includes the locale in the url of every relative link' do
        html = Capybara::Node::Simple.new(subject)

        expect(html).to have_link('Relative Link 1', href: '/en/relative/path/1')
        expect(html).to have_link('Relative Link 2', href: '/en/relative/path/2')
        expect(html).to have_link('NDP', href: 'https://developer.nexmo.com')
      end
    end

    context 'withouth one' do
      let(:locale) { nil }

      it 'does not alter the links' do
        html = Capybara::Node::Simple.new(subject)

        expect(html).to have_link('Relative Link 1', href: '/relative/path/1')
        expect(html).to have_link('Relative Link 2', href: '/relative/path/2')
        expect(html).to have_link('NDP', href: 'https://developer.nexmo.com')
      end
    end
  end
end
