require 'spec_helper'

RSpec.describe Nexmo::Markdown::AudioFilter do
  it 'turns audio links into audio player' do
    input = <<~HEREDOC
      🔈[https://nexmo-developer-production.s3.amazonaws.com/assets/ssml/01-hola.mp3]
    HEREDOC

    audio = <<~HEREDOC
      <audio preload="none" controls>
        <source src="https://nexmo-developer-production.s3.amazonaws.com/assets/ssml/01-hola.mp3" type="audio/mpeg">
      </audio>
    HEREDOC

    expected_output = "FREEZESTART#{Base64.urlsafe_encode64(audio)}FREEZEEND\n"

    expect(described_class.call(input)).to eq(expected_output)
  end
end
