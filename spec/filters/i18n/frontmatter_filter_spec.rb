require 'spec_helper'

RSpec.describe Nexmo::Markdown::I18n::FrontmatterFilter do
  let(:frontmatter) do
    <<~FRONTMATTER
      ---
      title: Overview
      meta_title: Send messages via: SMS, WhatsApp, Viber and Facebook Messenger
      navigation_weight: 1
      languages:
        - Node
        - Curl
        - Python
      ---
    FRONTMATTER
  end

  subject { described_class.call(frontmatter) }

  it 'escapes the keys with codeblocks since they are ignored by smartling' do
    expect(subject).to eq(
      <<~FRONTMATTER
        ---
        ```title:``` Overview

        ```meta_title:``` Send messages via: SMS, WhatsApp, Viber and Facebook Messenger

        ```navigation_weight:``` 1

        ```languages:```

          - ```Node```

          - ```Curl```

          - ```Python```

        ---
      FRONTMATTER
    )
  end

  context 'with products' do
    let(:frontmatter) do
      <<~FRONTMATTER
        ---
        title: Add a Call whisper to an inbound call
        products: voice/voice-api
        description: "Phone numbers are everywhere in advertising: on billboards, in TV ads, on websites, in newspapers. Often these numbers all redirect to the same call center, where an agent needs to inquire why the person is calling, and where they saw the advert. Call Whispers make this so much simpler."
        languages:
            - Node
        ---

        # Voice - Add a Call whisper to an inbound call
      FRONTMATTER
    end

    it 'escapes the frontmatter properly' do
      expect(subject).to eq(
        <<~FRONTMATTER
        ---
        ```title:``` Add a Call whisper to an inbound call

        ```products: voice/voice-api```

        ```description:``` "Phone numbers are everywhere in advertising: on billboards, in TV ads, on websites, in newspapers. Often these numbers all redirect to the same call center, where an agent needs to inquire why the person is calling, and where they saw the advert. Call Whispers make this so much simpler."

        ```languages:```

          - ```Node```

        ---

        # Voice - Add a Call whisper to an inbound call
        FRONTMATTER
      )
    end
  end
end
