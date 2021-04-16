# frozen_string_literal: true

require 'rails_helper'

describe 'UsersManagement::CreateUsersController - GET #set_up_confirmation', type: :request do
  subject { get set_up_confirmation_users_path }

  it 'does not require login' do
    subject
    expect(response).not_to redirect_to(new_user_session_path)
  end
end
