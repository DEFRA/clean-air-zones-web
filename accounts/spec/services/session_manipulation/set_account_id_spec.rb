# frozen_string_literal: true

require 'rails_helper'

describe SessionManipulation::SetAccountId do
  subject do
    described_class.call(session: session, params: { 'account_id' => account_id })
  end

  let(:session) { { company_name: {} } }
  let(:account_id) { '95d475c7-a39f-4752-b61e-c0269ceaa4c8' }

  it 'sets new_account account_id' do
    subject
    expect(session[:new_account]['account_id']).to eq(account_id)
  end
end
