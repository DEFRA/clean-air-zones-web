# frozen_string_literal: true

require 'rails_helper'

describe 'Organisations::OrganisationsController - GET #resend_email', type: :request do
  subject { get resend_email_organisations_path }

  let(:user) { create_user }
  let(:session_data) { { new_account: create_user.serializable_hash.merge(account_id: SecureRandom.uuid) } }

  before do
    add_to_session(session_data)
    allow(AccountsApi::Users).to receive(:resend_verification).and_return(true)
  end

  it 'calls AccountApi to resend the email' do
    subject
    expect(AccountsApi::Users).to have_received(:resend_verification)
  end

  it 'returns a redirect to email_sent' do
    subject
    expect(response).to redirect_to(email_sent_organisations_path)
  end

  context 'without new_account data in the session' do
    let(:session_data) { { new_account: { account_id: SecureRandom.uuid } } }

    it 'does not call AccountApi to resend the email' do
      subject
      expect(AccountsApi::Users).not_to have_received(:resend_verification)
    end

    it 'returns a redirect to root_path' do
      subject
      expect(response).to redirect_to(root_path)
    end
  end
end
