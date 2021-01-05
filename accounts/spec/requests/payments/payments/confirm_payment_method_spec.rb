# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentsController - POST #confirm_payment_method' do
  subject { post select_payment_method_payments_path, params: { payment_method: payment_method } }

  let(:payment_method) { 'false' }

  context 'correct permissions' do
    before do
      add_to_session(new_payment: { caz_id: @uuid, details: {} })
      allow(PaymentsApi).to receive(:create_payment).and_return(
        'paymentId': @uuid,
        'nextUrl': result_payments_path
      )
      sign_in create_user
      subject
    end

    context 'when user selects the Card payment method' do
      it 'redirects to the initiate payment path' do
        expect(response).to redirect_to(initiate_payments_path)
      end
    end

    context 'when user selects the Direct Debit method' do
      let(:payment_method) { 'true' }

      it 'redirects to the confirm Direct Debit payment page' do
        expect(response).to redirect_to(confirm_debits_path)
      end
    end

    context 'when user does not select a method' do
      let(:payment_method) { '' }

      it 'rerenders the page' do
        expect(response).to render_template(:select_payment_method)
      end

      it 'assigns correct error message' do
        expect(assigns(:errors)).to eq('Choose Direct Debit or card payment')
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
