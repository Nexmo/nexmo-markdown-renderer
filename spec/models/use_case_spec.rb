require 'spec_helper'

RSpec.describe Nexmo::Markdown::UseCase, type: :model do
  describe '.all' do
    it 'returns an array of Tutorials' do
      tutorials = described_class.all
      expect(tutorials).to be_an(Array)
      expect(tutorials[0]).to be_a(Nexmo::Markdown::UseCase)
    end
  end

  describe '.by_product' do
    it 'returns only use_case for the specified product type' do
      tutorials = described_class.by_product('voice/voice-api')
      expect(tutorials).to be_an(Array)
      expect(tutorials[0]).to be_a(Nexmo::Markdown::UseCase)

      tutorials.each do |tutorial|
        expect(tutorial.products).to include('voice/voice-api')
      end
    end

    it 'returns an empty array when given an invalid product' do
      tutorials = described_class.by_product('some_invalid_product')
      expect(tutorials).to eq([])
    end
  end

  describe '.by_language' do
    it 'returns only use_case for the specified language' do
      tutorials = described_class.by_language('Node')
      expect(tutorials).to be_a(Array)
      expect(tutorials).not_to be_empty

      tutorials.each do |tutorial|
        expect(tutorial.languages).to include('Node')
      end
    end
  end

  describe '#body' do
    it 'returns a string' do
      expect(described_class.all[0].body).to be_a(String)
    end
  end

  describe '#path' do
    it 'returns a path' do
      expect(described_class.all[0].path).to start_with('/use-cases/')
    end
  end
end
