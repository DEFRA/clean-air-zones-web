# frozen_string_literal: true

require 'rails_helper'

describe SessionManipulation::SetPaymentDetails do
  subject do
    described_class.call(
      session: session,
      email: email,
      payment_reference: payment_reference,
      external_id: external_id
    )
  end

  let(:session) { { initiated_payment: {} } }
  let(:email) { 'test@example.com' }
  let(:payment_reference) { 1 }
  let(:external_id) { 'external payment id' }

  it 'sets email' do
    subject
    expect(session[:initiated_payment][:user_email]).to eq(email)
  end

  it 'sets payment reference' do
    subject
    expect(session[:initiated_payment][:payment_reference]).to eq(payment_reference)
  end

  it 'sets email' do
    subject
    expect(session[:initiated_payment][:external_id]).to eq(external_id)
  end
end
