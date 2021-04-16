# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentHistory::PaymentHistoryController - GET #payment_history', type: :request do
  subject { get payment_history_path, params: { page: 2, per_page: 10 } }

  context 'when correct permissions' do
    before do
      mock_actual_account_name
      sign_in user
    end

    let(:user) { view_payment_history_user }

    context 'with api returns OK status' do
      before { mock_payment_history }

      context 'with make payments permissions' do
        let(:user) { make_payments_user }

        it 'renders the view' do
          expect(subject).to render_template(:payment_history)
        end

        it 'calls PaymentHistory::History to resend the email' do
          subject
          expect(PaymentHistory::History).to have_received(:new)
        end
      end

      context 'with view payments history permissions' do
        it 'renders the view' do
          expect(subject).to render_template(:payment_history)
        end

        it 'calls PaymentHistory::History to resend the email' do
          subject
          expect(PaymentHistory::History).to have_received(:new).with(user.account_id, user.user_id, false)
        end
      end
    end

    context 'with apu returns 400 status with invalid page' do
      before do
        allow(PaymentHistoryApi).to receive(:payments).and_raise(
          BaseApi::Error400Exception.new(400, '', {})
        )
        subject
      end

      it 'redirects to the payment history page' do
        expect(response).to redirect_to payment_history_path
      end
    end
  end

  it_behaves_like 'incorrect permissions'
  it_behaves_like 'a login required'
end
