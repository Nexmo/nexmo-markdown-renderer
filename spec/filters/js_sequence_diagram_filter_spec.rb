require 'rails_helper'

RSpec.describe JsSequenceDiagramFilter do
  it 'formats text in between three ``` and "js_sequence_diagram"' do
    input = <<~HEREDOC
      ```js_sequence_diagram
      some text here
      ```
    HEREDOC

    expected_output = "FREEZESTARTPGRpdiBjbGFzcz0ianMtZGlhZ3JhbSI-CiAgCnNvbWUgdGV4dCBoZXJlCgo8L2Rpdj4KFREEZEEND\n"

    expect(described_class.call(input)).to eq(expected_output)
  end

  it 'does not format text that does not have ``` and "js_sequence_diagram" in front of it' do
    input = <<~HEREDOC
      some text here
    HEREDOC

    expected_output = "some text here\n"

    expect(described_class.call(input)). to eq(expected_output)
  end
end
