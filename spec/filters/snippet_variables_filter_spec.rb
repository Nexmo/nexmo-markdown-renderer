require 'spec_helper'

RSpec.describe Nexmo::Markdown::SnippetVariablesFilter do
  it 'returns whitespace with whitespace input' do
    expect(described_class.call('')).to eql('')
  end

  it 'returns unaltered non-matching input' do
    input = 'some text'
    expect(described_class.call(input)).to eql(input)
  end

  it 'outputs multiple lines' do
    input = <<~HEREDOC
      ```snippet_variables
      - NEXMO_API_KEY
      - NEXMO_API_SECRET
      ```
    HEREDOC

    expected_output = <<~HEREDOC
      Key | Description
      -- | --
      `NEXMO_API_KEY` | You can find this in your account overview
      `NEXMO_API_SECRET` | You can find this in your account overview, too

    HEREDOC

    expect(described_class.call(input)).to eq(expected_output)
  end

  it 'allows for product specific placeholders' do
    input = <<~HEREDOC
      ```snippet_variables
      - TO_NUMBER.VOICE
      - UUID.MODIFY.VOICE
      ```
    HEREDOC

    expected_output = <<~HEREDOC
      Key | Description
      -- | --
      `TO_NUMBER` | The number you are calling
      `UUID` | The call to modify

    HEREDOC

    expect(described_class.call(input)).to eq(expected_output)
  end

  it 'throws with an empty list' do
    input = <<~HEREDOC
      ```snippet_variables
      ```
    HEREDOC

    expect do
      described_class.new.call(input)
    end.to raise_error('No variables provided')
  end

  it 'throws with the wrong data type' do
    input = <<~HEREDOC
      ```snippet_variables
      Not a list
      ```
    HEREDOC

    expect do
      described_class.new.call(input)
    end.to raise_error('Must provide an array')
  end

  it 'throws when a variable cannot be found' do
    input = <<~HEREDOC
      ```snippet_variables
      - INVALID_NAME
      ```
    HEREDOC

    expect do
      described_class.new.call(input)
    end.to raise_error('INVALID_NAME is not a valid snippet variable')
  end

  it 'throws when a variable does not have a description' do
    input = <<~HEREDOC
      ```snippet_variables
      - NO_DESCRIPTION
      ```
    HEREDOC

    expect do
      described_class.new.call(input)
    end.to raise_error('NO_DESCRIPTION is not a valid snippet variable')
  end

end
