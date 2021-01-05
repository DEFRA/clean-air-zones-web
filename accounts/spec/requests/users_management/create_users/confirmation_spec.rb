# frozen_string_literal: true

require 'rails_helper'

describe 'UsersManagement::CreateUsersController - GET #confirmation' do
  subject { get confirmation_users_path }

  context 'correct permissions' do
    before { sign_in manage_users_user }

    it 'renders the view' do
      expect(subject).to render_template(:confirmation)
    end
  end

  it_behaves_like 'incorrect permissions'
  it_behaves_like 'a login required'
end
