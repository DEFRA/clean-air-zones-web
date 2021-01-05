# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentsController - GET #review_details' do
  subject { get review_details_payments_path }

  context 'correct permissions' do
    let(:payment_details) do
      { 'PAY001' =>
        { vrn: 'PAY001',
          tariff: 'BCC01-HEAVY GOODS VEHICLE',
          charge: 50.0,
          dates: ['13 October 2020'] } }
    end

    before do
      sign_in create_user
      add_to_session(new_payment: { caz_id: @uuid,
                                    details: payment_details })
      subject
    end

    it 'assigns :details variable' do
      expect(assigns(:details)).to eq(payment_details)
    end
  end

  it_behaves_like 'incorrect permissions'
end
