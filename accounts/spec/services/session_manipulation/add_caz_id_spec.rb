# frozen_string_literal: true

require 'rails_helper'

describe SessionManipulation::AddCazId do
  subject { described_class.call(session: session, caz_id: caz_id) }

  let(:caz_id) { SecureRandom.uuid }
  let(:session) { {} }
  let(:vrn) { 'ABC123' }

  before { subject }

  it 'sets caz_id' do
    expect(session[:new_payment]).to eq({ caz_id: caz_id })
  end

  context 'when there is other data in the session' do
    let(:session) { { new_payment: { caz_id: SecureRandom.uuid, details: { vrn => [] } } } }

    it 'clears other data than caz_id' do
      expect(session[:new_payment]).to eq({ caz_id: caz_id })
    end
  end

  context 'when there is data for the same LA' do
    let(:payment_data) { { caz_id: caz_id, details: { vrn => [] } } }
    let(:session) { { new_payment: payment_data } }

    it 'keeps the data' do
      expect(session[:new_payment]).to eq(payment_data)
    end
  end

  context 'when query params are present' do
    let(:session) { { payment_query: { search: vrn } } }

    it 'removes payment query' do
      expect(session.keys).not_to include(:payment_query)
    end
  end
end
