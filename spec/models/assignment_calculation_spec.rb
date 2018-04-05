require 'rails_helper'

RSpec.describe AssignmentsCalculation do
  let(:fingerprint) { 'f-f-f-fingerprint' }
  let(:app) { FactoryBot.create :app }
  let!(:splits) { FactoryBot.create_list(:split, 3, owner_app_id: app.id) }
  let(:id_type) do
    IdentifierType.create!(name: 'user_id',
                           owner_app_id: app.id)
  end
  let(:user_id) { nil }

  subject { described_class.new(fingerprint, user_id, id_type.id) }


  context 'fingerprint only' do
    it 'returns assignments for all splits' do
      expect(subject.call[:assignments].keys.count).to eq(3)
    end

    it 'stores assignments' do
      subject.call
      expect(Assignment.count).to eq(3)
    end
  end

  context 'with existing user_id' do
    let(:another_fingerprint) { 'another-fingerprint' }
    let(:user_id) { '123' }
    let(:visitor) { FactoryBot.create :visitor }
    let(:split) { splits.first }

    let!(:old_results) { described_class.new(another_fingerprint, user_id, id_type.id).call }

    it 'returns canonical visitor splits' do
      expect(subject.call).to eq(old_results)
    end

    it 'associates new fingerprint with user_id' do
      subject.call
      visitor = Visitor.find_by(fingerprint: fingerprint)
      id = Identifier.find_by(visitor_id: visitor.id, value: user_id)
      expect(id).not_to be_nil
    end
  end
end
