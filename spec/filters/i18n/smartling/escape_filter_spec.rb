require 'spec_helper'

RSpec.describe Nexmo::Markdown::I18n::Smartling::EscapeFilter do
  let(:table) do
    <<~TABLE
      密钥 \| 说明
      \-\- \| \-\-
      `NEXMO_API_KEY` \| 您的 Nexmo API 密钥。
      `NEXMO_API_SECRET` \| 您的 Nexmo API 密码。
    TABLE
  end

  let(:string) do
    <<~STRING
      > 
      ^\\[个支持的字符\\]\\(abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789\\)
    STRING
  end

  it 'unescapes special characters to form a table' do
    translated = described_class.call(table)

    expect(translated).to include(
      <<~TABLE
        密钥 | 说明
        -- | --
        `NEXMO_API_KEY` | 您的 Nexmo API 密钥。
        `NEXMO_API_SECRET` | 您的 Nexmo API 密码。
      TABLE
    )
  end

  it 'unescapes special characters and remove others' do
    translated = described_class.call(string)

    expect(translated).to eq(
      <<~STRING

        ^\[个支持的字符\]\(abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789\)
      STRING
    )
  end
end
