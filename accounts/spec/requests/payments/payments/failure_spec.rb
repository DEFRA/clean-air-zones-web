# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentsController - GET #failure' do
  subject { get failure_payments_path }

  context 'correct permissions' do
    let(:payment_data) do
      { caz_id: @uuid,
        details: { 'PAY001' =>
                   { vrn: 'PAY001',
                     charge: 50.0,
                     dates: ['13 October 2020', '14 October 2020', '15 October 2020'] } },
        payment_reference: 1234 }
    end

    before do
      mock_clean_air_zones
      sign_in create_user
      add_to_session(initiated_payment: payment_data)
      subject
    end

    it_behaves_like 'payment result page'
  end

  it_behaves_like 'incorrect permissions'
end
