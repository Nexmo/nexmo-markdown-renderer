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
  end
end
