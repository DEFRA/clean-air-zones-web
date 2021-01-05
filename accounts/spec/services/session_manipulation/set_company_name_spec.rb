# frozen_string_literal: true

require 'rails_helper'

describe SessionManipulation::SetCompanyName do
  subject do
    described_class.call(session: session, params: { company_name: company_name })
  end

  let(:session) { { company_name: {} } }
  let(:company_name) { 'Test company' }

  it 'sets new_account company_name' do
    subject
    expect(session[:new_account][:company_name]).to eq(company_name)
  end
end
