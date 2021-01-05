# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentHistory::PaymentHistoryController - GET #user_payment_history' do
  subject { get user_payment_history_path, params: { page: 2 } }

  context 'correct permissions' do
    before do
      api_response = read_response('payment_history/payments.json')['1']
      allow(PaymentHistoryApi).to receive(:payments).and_return(api_response)
      sign_in make_payments_user
    end

    it 'renders the view' do
      expect(subject).to render_template(:user_payment_history)
    end

    context 'and with invalid page' do
      before do
        allow(PaymentHistoryApi).to receive(:payments).and_raise(
          BaseApi::Error400Exception.new(400, '', {})
        )
        subject
      end

      it 'redirects to the user payment history page' do
        expect(response).to redirect_to user_payment_history_path
      end
    end
  end

  it_behaves_like 'incorrect permissions'
  it_behaves_like 'a login required'
end
