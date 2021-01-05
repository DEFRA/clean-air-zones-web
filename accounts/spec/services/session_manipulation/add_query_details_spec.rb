# frozen_string_literal: true

require 'rails_helper'

describe SessionManipulation::AddQueryDetails do
  subject do
    described_class.call(params: params, session: session)
  end

  let(:id) { @uuid }
  let(:params) do
    {
      commit: commit,
      payment: { vrn_search: search, next_vrn: vrn1, previous_vrn: vrn2 }
    }.with_indifferent_access
  end
  let(:commit) { 'Search' }
  let(:search) { 'test' }
  let(:vrn1) { 'CAZ300' }
  let(:vrn2) { 'CAZ400' }
  let(:session) { {} }

  before { subject }

  it 'saves only the search value' do
    expect(session[:payment_query]).to eq({ search: search })
  end

  context 'when commit is Search' do
    let(:commit) { 'Search' }

    it 'saves the search value' do
      expect(session[:payment_query]).to eq(
        { search: search }
      )
    end
  end

  context 'when commit is Next' do
    let(:commit) { 'Next' }

    it 'saves next VRN and direction value' do
      expect(session[:payment_query]).to eq(
        { vrn: vrn1, direction: 'next' }
      )
    end
  end

  context 'when commit is Previous' do
    let(:commit) { 'Previous' }

    it 'saves next VRN and direction value' do
      expect(session[:payment_query]).to eq(
        { vrn: vrn2, direction: 'previous' }
      )
    end
  end
end
