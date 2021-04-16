# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentHistory::PaymentHistoryController - GET #payment_history_details', type: :request do
  subject do
    get payment_history_details_path, params: { payment_id: SecureRandom.uuid },
                                      headers: { HTTP_REFERER: last_page }
  end

  let(:last_page) { payment_history_path }

  context 'when correct permissions' do
    before do
      api_response = read_response('payment_history/payment_details.json')
      allow(PaymentHistoryApi).to receive(:payment_details).and_return(api_response)
      sign_in make_payments_user
      subject
    end

    it 'renders the view' do
      expect(response).to render_template(:payment_history_details)
    end

    context 'when last visited page was the Company payment history page' do
      it 'adding `company_payment_history` to the session' do
        expect(session[:company_payment_history]).to be_truthy
      end

      it 'adding `payment_details_back_link` to the session' do
        expect(session[:payment_details_back_link]).to eq(last_page)
      end
    end

    context 'when no last visited page' do
      let(:last_page) { nil }

      it 'not adding `company_payment_history` to the session' do
        expect(session[:company_payment_history]).to be_nil
      end

      it 'adding `payment_details_back_link` to the session' do
        expect(session[:payment_details_back_link]).to eq(payment_history_path)
      end
    end
  end

  it_behaves_like 'incorrect permissions'
  it_behaves_like 'a login required'
end
