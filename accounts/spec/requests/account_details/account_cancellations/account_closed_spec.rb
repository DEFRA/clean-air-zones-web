# frozen_string_literal: true

require 'rails_helper'

describe 'AccountsDetails::AccountCancellationsController - GET #account_closed', type: :request do
  subject { get account_closed_path }

  before { subject }

  it 'returns a 200 OK status' do
    expect(response).to have_http_status(:ok)
  end

  it 'renders the view' do
    expect(response).to render_template(:account_closed)
  end
end
