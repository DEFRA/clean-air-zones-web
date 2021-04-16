# frozen_string_literal: true

require 'rails_helper'

describe 'DirectDebits::DebitsController - POST #set_up', type: :request do
  subject { post set_up_debits_path, params: { caz_id: caz_id } }

  let(:caz_id) { SecureRandom.uuid }
  let(:user) { manage_mandates_user }

  context 'when correct permissions' do
    before do
      mock_direct_debit_enabled
      sign_in user
    end

    context 'when user selects the LA' do
      before do
        allow(DebitsApi).to receive(:create_mandate).and_return(read_response('debits/create_mandate.json'))
        mock_debits
      end

      it 'redirects to the :complete_setup endpoint' do
        subject
        expect(response).to redirect_to(/#{complete_setup_debits_path}/)
      end

      it 'adds a new mandate' do
        subject
        expect(DebitsApi).to have_received(:create_mandate).with(
          account_id: user.account_id,
          account_user_id: user.user_id,
          caz_id: caz_id,
          return_url: complete_setup_debits_url,
          session_id: anything
        )
      end
    end

    context 'when the user does not select option' do
      let(:caz_id) { nil }

      before { subject }

      it 'redirects to the new' do
        expect(response).to redirect_to(set_up_debits_path)
      end

      it 'sets alert message' do
        expect(flash[:alert]).to eq(I18n.t('la_form.la_missing'))
      end
    end
  end

  it_behaves_like 'incorrect permissions'

  context 'when Direct Debits feature disabled' do
    before do
      mock_direct_debit_disabled
      mock_debits
      allow(DebitsApi).to receive(:create_mandate).and_return(read_response('debits/create_mandate.json'))
      sign_in user
      subject
    end

    it 'redirects to the :complete_setup endpoint' do
      expect(response).to redirect_to(/#{complete_setup_debits_path}/)
    end
  end
end
