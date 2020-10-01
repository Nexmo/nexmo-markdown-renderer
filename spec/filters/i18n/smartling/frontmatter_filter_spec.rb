require 'spec_helper'

RSpec.describe Nexmo::Markdown::I18n::Smartling::FrontmatterFilter do
  let(:frontmatter) do
    <<~FRONTMATTER
      *** ** * ** ***

      `title:`Before you begin
      `navigation_weight:` 0
      ------------------------------------------
    FRONTMATTER
  end

  it 'translates the frontmatter to yaml' do
    translated = described_class.call(frontmatter)
    expect(translated).to eq(
      <<~FRONTMATTER
        ---
        title: Before you begin
        navigation_weight:  0

        ---

      FRONTMATTER
    )
  end
end
