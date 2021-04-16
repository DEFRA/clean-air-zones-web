# frozen_string_literal: true

require 'rails_helper'

describe SessionManipulation::SetPaymentId do
  subject { described_class.call(session: session, params: { payment_id: id }) }

  let(:session) { { new_payment: {} } }
  let(:id) { SecureRandom.uuid }

  it 'sets payment id' do
    subject
    expect(session[:new_payment][:payment_id]).to eq(id)
  end
end
