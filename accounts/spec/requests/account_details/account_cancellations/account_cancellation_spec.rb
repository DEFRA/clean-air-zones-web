# frozen_string_literal: true

require 'rails_helper'

describe 'AccountsDetails::AccountCancellationsController - GET #account_cancellation', type: :request do
  subject { get account_cancellation_path }

  before do
    sign_in create_owner
    subject
  end

  it 'returns a 200 OK status' do
    expect(response).to have_http_status(:ok)
  end

  it 'renders the view' do
    expect(response).to render_template(:account_cancellation)
  end
end
