# frozen_string_literal: true

require 'rails_helper'

describe 'Organisations::OrganisationsController - GET #email_sent' do
  subject { get email_sent_organisations_path }

  let(:session_data) { { new_account: create_user.serializable_hash.merge(company_name: 'Company name') } }

  before do
    add_to_session(session_data)
    subject
  end

  it 'returns a 200 OK status' do
    expect(response).to have_http_status(:ok)
  end

  context 'without new_account data in the session' do
    let(:session_data) { { new_account: { 'account_id': @uuid } } }

    it 'returns a redirect' do
      expect(response).to redirect_to(root_path)
    end
  end
end
