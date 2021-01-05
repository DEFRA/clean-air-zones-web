# frozen_string_literal: true

require 'rails_helper'

describe 'PasswordsController - GET #invalid' do
  subject { get invalid_passwords_path }

  it 'returns a 200 OK status' do
    subject
    expect(response).to have_http_status(:ok)
  end
end
