require 'spec_helper'

RSpec.describe Nexmo::Markdown::CodeSnippetRenderer::Curl do
  it 'ignores snippets that do not have single quotes' do
    input = <<~HEREDOC.strip
curl -X "POST" "https://rest.nexmo.com/sms/json" \
  -d "from=$VONAGE_BRAND_NAME" \
  -d "text=A text message sent using the Vonage SMS API" \
  -d "to=$TO_NUMBER" \
  -d "api_key=$VONAGE_API_KEY" \
  -d "api_secret=$VONAGE_API_SECRET"
    HEREDOC
    expect(described_class.post_process(input)).to eq(input)
  end

  it 'removes single quotes around a variable' do
    input = <<~HEREDOC.strip
curl -X POST https://api.nexmo.com/v1/calls\
  -H "Authorization: Bearer "$JWT\
  -H "Content-Type: application/json"\
  -d '{"to":[{"type": "phone","number": "'$TO_NUMBER'"}],
      "from": {"type": "phone","number": "'$VONAGE_NUMBER'"},
      "ncco": [
        {
          "action": "talk",
          "text": "This is a text to speech call from Vonage"
        }
      ]}'
    HEREDOC

    expected = <<~HEREDOC.strip
curl -X POST https://api.nexmo.com/v1/calls\
  -H "Authorization: Bearer "$JWT\
  -H "Content-Type: application/json"\
  -d '{"to":[{"type": "phone","number": "$TO_NUMBER"}],
      "from": {"type": "phone","number": "$VONAGE_NUMBER"},
      "ncco": [
        {
          "action": "talk",
          "text": "This is a text to speech call from Vonage"
        }
      ]}'
    HEREDOC
    expect(described_class.post_process(input)).to eq(expected)
  end
end