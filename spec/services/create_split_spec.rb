require 'rails_helper'

RSpec.describe CreateSplit do
  subject { described_class.new(params) }
  context 'valid params' do
    let(:app) { FactoryBot.create(:app) }
    let(:params) do
      {
        'registry' => {a: 50, b: 50}.to_json,
        'name' => "fuck-you",
        'owner_app_id' => app.id
      }
    end

    it 'creates split' do
      expect(subject.call[:success]).to eq(true)
    end

    it 'split has no errors on it' do
      expect(subject.call[:split].errors[:registry]).not_to be_nil
    end
  end

  context 'invalid' do
    let(:params) do
      {
        registry: {a: 50, b: 50}.to_json()[1..-1],
        name: "dontcare"
      }
    end

    it 'returns hash with success => false' do
      expect(subject.call[:success]).to eq(false)
    end

    it 'adds error to split' do
      expect(subject.call[:split].errors[:registry]).not_to be_nil
    end
  end
end
