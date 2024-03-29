# frozen_string_literal: true

require 'rails_helper'

describe 'PasswordsController - GET #new', type: :request do
  subject { get new_password_path }

  before do
    sign_in user
    subject
  end

  context 'when user aws_status is OK' do
    let(:user) { new_user(aws_status: 'OK') }

    it 'returns a redirect to root_path' do
      expect(response).to redirect_to(root_path)
    end
  end

  context 'when user aws_session is missing' do
    let(:user) { new_user(aws_status: 'FORCE_NEW_PASSWORD') }

    it 'returns a redirect to new_user_session_path' do
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'with valid params' do
    let(:user) do
      new_user(
        aws_status: 'FORCE_NEW_PASSWORD',
        aws_session: 'a651dc86-2c3f-4ba2-8b1e-c23b5cdeb59a'
      )
    end

    it 'returns 200' do
      expect(response).to be_successful
    end
  end
end
