# frozen_string_literal: true

require 'rails_helper'

describe SessionManipulation::AddQueryDetails do
  subject { described_class.call(params: params, session: session) }

  let(:id) { SecureRandom.uuid }
  let(:params) { { commit: commit, payment: { vrn_search: search } }.with_indifferent_access }
  let(:commit) { 'SEARCH' }
  let(:search) { 'test' }
  let(:session) { {} }

  before { subject }

  it 'saves only the search value' do
    expect(session[:payment_query]).to eq({ search: search })
  end

  context 'when commit is `SEARCH`' do
    let(:commit) { 'SEARCH' }

    it 'saves the search value' do
      expect(session[:payment_query]).to eq({ search: search })
    end
  end

  context 'when commit is `CLEARSEARCH`' do
    let(:commit) { 'CLEARSEARCH' }

    it 'clears the search value' do
      expect(session[:payment_query]).to be_empty
    end
  end
end
