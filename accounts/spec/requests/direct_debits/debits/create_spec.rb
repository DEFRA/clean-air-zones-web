# frozen_string_literal: true

require 'rails_helper'

describe 'DirectDebits::DebitsController - POST #create' do
  subject { post debits_path, params: { caz_id: caz_id } }

  let(:caz_id) { @uuid }
  let(:user) { manage_mandates_user }

  context 'correct permissions' do
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
        expect(DebitsApi).to receive(:create_mandate).with(
          account_id: user.account_id,
          caz_id: caz_id,
          return_url: complete_setup_debits_url,
          session_id: anything
        )
        subject
      end
    end

    context 'when the user does not select option' do
      let(:caz_id) { nil }

      before { subject }

      it 'redirects to the new' do
        expect(response).to redirect_to(new_debit_path)
      end

      it 'sets alert message' do
        expect(flash[:alert]).to eq(I18n.t('la_form.la_missing'))
      end

      it 'does not add a new mandate' do
        expect(DebitsApi).not_to receive(:create_mandate)
      end
    end
  end

  it_behaves_like 'incorrect permissions'

  context 'when Direct Debits feature disabled' do
    before do
      mock_direct_debit_disabled
      sign_in user
      subject
    end

    it 'redirects to the not found page' do
      expect(response).to redirect_to(not_found_path)
    end
  end
end
