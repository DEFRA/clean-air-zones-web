# frozen_string_literal: true

require 'rails_helper'

describe 'Payments::CreditCardsController - POST #initiate' do
  subject do
    get initiate_payments_path
  end

  before do
    add_to_session(new_payment: { caz_id: @uuid })
    response = { 'paymentId' => @uuid, 'nextUrl' => '/payments/result' }
    allow(Payments::MakeCardPayment).to receive(:call).and_return(response)
    sign_in create_user
    subject
  end

  it 'redirects to the result payment page' do
    subject
    expect(response).to redirect_to(result_payments_path)
  end
end
