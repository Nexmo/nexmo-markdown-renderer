require 'spec_helper'

RSpec.describe Nexmo::Markdown::I18n::Smartling::FrontmatterFilter do

  subject { described_class.call(frontmatter) }

  context "without products" do
    let(:frontmatter) do
      <<~FRONTMATTER
      *** ** * ** ***

      `title:`Before you begin
      `navigation_weight:` 0
      ------------------------------------------
      FRONTMATTER
    end

    it 'translates the frontmatter to yaml' do
      expect(subject).to eq(
        <<~FRONTMATTER
        ---
        title: Before you begin
        navigation_weight:  0

        ---

        FRONTMATTER
      )
    end
  end

  describe "with products" do
    let(:frontmatter) do
      <<~FRONTMATTER
        *** ** * ** ***

        `title:` \[Á~ddá~Cáll~whís~pért~óáñ~íñbó~úñdc~áll\]

        `products: voice/voice-api`

        `description:` \["P~hóñ~éñúm~bérs~áréé~vérý~whér~éíñá~dvér~tísí~ñg:ó~ñbíl~lbóá~rds,~íñTV~áds,~óñwé~bsít~és,í~ññéw~spáp~érs.~Ófté~ñthé~séñú~mbér~sáll~rédí~réct~tóth~ésám~écál~lcéñ~tér,~whér~éáñá~géñt~ñééd~stóí~ñqúí~réwh~ýthé~pérs~óñís~cáll~íñg,~áñdw~héré~théý~sáwt~héád~vért~.Cál~lWhí~spér~smák~éthí~ssóm~úchs~ímpl~ér."\]

        `languages:`

        * `Node`

        * `Python`
        *** ** * ** ***
      FRONTMATTER
    end

    it 'translates the frontmatter to yaml' do
      expect(subject).to eq(
        <<~FRONTMATTER
        ---
        title:  \[Á~ddá~Cáll~whís~pért~óáñ~íñbó~úñdc~áll\]

        products: voice/voice-api

        description:  \["P~hóñ~éñúm~bérs~áréé~vérý~whér~éíñá~dvér~tísí~ñg:ó~ñbíl~lbóá~rds,~íñTV~áds,~óñwé~bsít~és,í~ññéw~spáp~érs.~Ófté~ñthé~séñú~mbér~sáll~rédí~réct~tóth~ésám~écál~lcéñ~tér,~whér~éáñá~géñt~ñééd~stóí~ñqúí~réwh~ýthé~pérs~óñís~cáll~íñg,~áñdw~héré~théý~sáwt~héád~vért~.Cál~lWhí~spér~smák~éthí~ssóm~úchs~ímpl~ér."\]

        languages:
          - Node
          - Python

        ---

        FRONTMATTER
      )
    end

    context 'with one product' do
      let(:frontmatter) do
        <<~FRONTMATTER
          *** ** * ** ***

          `title:` \[Á~ddá~Cáll~whís~pért~óáñ~íñbó~úñdc~áll\]

          `products: voice/voice-api`

          `description:` \["P~hóñ~éñúm~bérs~áréé~vérý~whér~éíñá~dvér~tísí~ñg:ó~ñbíl~lbóá~rds,~íñTV~áds,~óñwé~bsít~és,í~ññéw~spáp~érs.~Ófté~ñthé~séñú~mbér~sáll~rédí~réct~tóth~ésám~écál~lcéñ~tér,~whér~éáñá~géñt~ñééd~stóí~ñqúí~réwh~ýthé~pérs~óñís~cáll~íñg,~áñdw~héré~théý~sáwt~héád~vért~.Cál~lWhí~spér~smák~éthí~ssóm~úchs~ímpl~ér."\]

          `languages:`

          * `Node`

          *** ** * ** ***

        FRONTMATTER
      end

      it 'translates the frontmatter to yaml' do
        expect(subject).to eq(
          <<~FRONTMATTER
        ---
        title:  \[Á~ddá~Cáll~whís~pért~óáñ~íñbó~úñdc~áll\]

        products: voice/voice-api

        description:  \["P~hóñ~éñúm~bérs~áréé~vérý~whér~éíñá~dvér~tísí~ñg:ó~ñbíl~lbóá~rds,~íñTV~áds,~óñwé~bsít~és,í~ññéw~spáp~érs.~Ófté~ñthé~séñú~mbér~sáll~rédí~réct~tóth~ésám~écál~lcéñ~tér,~whér~éáñá~géñt~ñééd~stóí~ñqúí~réwh~ýthé~pérs~óñís~cáll~íñg,~áñdw~héré~théý~sáwt~héád~vért~.Cál~lWhí~spér~smák~éthí~ssóm~úchs~ímpl~ér."\]

        languages:
          - Node


        ---

          FRONTMATTER
        )
      end

    end

    context 'with completed translation' do
      let(:frontmatter) do
        File.read('spec/fixtures/pre-processed/_tutorials/en/_use_cases/add-a-call-whisper-to-an-inbound-call.md')
      end

      it 'replaces the frontmatter Smartling format with Nexmo format' do
        expect(subject).to include(
          <<~FRONTMATTER
          ---
          title:  着信コールにCall Whisperを追加する
          
          products: voice/voice-api
          
          description:  「電話番号は、看板、テレビ広告、Webサイト、新聞など、広告のいたるところに掲載されています。多くの場合、これらの番号はすべて同じコールセンターにリダイレクトされます。コールセンターのエージェントは、その人が電話をかけている理由と、広告を見た場所を尋ねる必要があります。Call Whisperを使用すると、これがとても簡単になります。」
          
          languages:
            - Node
          
          ---
          FRONTMATTER
        )
      end
    end
  end
end
