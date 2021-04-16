# frozen_string_literal: true

require 'rails_helper'

describe 'Organisations::OrganisationsController - GET #create_account', type: :request do
  subject { get create_account_path }

  it 'returns a 200 OK status' do
    subject
    expect(response).to have_http_status(:ok)
  end
end
