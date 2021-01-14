require 'spec_helper'

RSpec.describe Nexmo::Markdown::Filters::CodeSnippet::ImportDependencies do
  describe 'render' do
    let(:config) do
      {
        "source"    => "repos/vonage/vonage-dotnet-code-snippets/SendSms.cs",
        "from_line" => 1,
        "to_line"   => 2
      }
    end
    let(:snippet) do
      Nexmo::Markdown::Filters::CodeSnippet::Binding.new(
        YAML.safe_load(File.read('spec/filters/fixtures/examples/send-an-sms/csharp.yml'))
      )
    end

    subject { described_class.new(config, snippet) }

    it 'renders the dependencies' do
      rendered = Capybara::Node::Simple.new(subject.render)

      expect(rendered).to have_button('Import dependencies')
    end
  end
end
