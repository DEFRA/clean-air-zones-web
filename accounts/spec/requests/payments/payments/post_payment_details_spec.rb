# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentsController - GET #post_payment_details' do
  subject { get post_payment_details_payments_path }

  context 'correct permissions' do
    let(:payment_details) { { @vrn => { dates: %w[2019-11-05 2019-11-06], charge: 50 } } }

    before do
      mock_clean_air_zones
      sign_in create_user
      add_to_session(initiated_payment: { caz_id: @uuid,
                                          details: payment_details })
    end

    it 'assigns :details variable' do
      subject
      expect(assigns(:details)).to eq(payment_details)
    end
  end

  it_behaves_like 'incorrect permissions'
end
