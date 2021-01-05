# frozen_string_literal: true

require 'rails_helper'

describe 'UsersManagement::RemoveUsersController - GET #remove' do
  subject { get remove_user_path(@uuid) }

  context 'correct permissions' do
    context 'with edit user data in session' do
      before { add_to_session(edit_user: { name: 'John Doe' }) }

      context 'when user is exist in db' do
        before do
          sign_in manage_users_user
          mock_user_details
        end

        it 'renders the view' do
          expect(subject).to render_template(:remove)
        end
      end

      context 'when user want to delete his own account' do
        before { sign_in manage_users_user(user_id: @uuid) }

        it 'redirects to the users page' do
          expect(subject).to redirect_to users_path
        end
      end
    end

    context 'without edit user data in session' do
      before { sign_in manage_users_user }

      it 'redirects to the users page' do
        expect(subject).to redirect_to users_path
      end
    end
  end

  it_behaves_like 'incorrect permissions'
  it_behaves_like 'a login required'
end
