# frozen_string_literal: true

require 'rails_helper'

describe 'UsersManagement::RemoveUsersController - POST #confirm_remove', type: :request do
  subject { post remove_user_path(user_id), params: params }

  let(:params) { { 'confirm-remove-user': confirmation } }
  let(:user_id) { SecureRandom.uuid }
  let(:confirmation) { 'yes' }

  context 'when correct permissions' do
    context 'with edit user data in session' do
      before { add_to_session(edit_user: { name: 'John Doe' }) }

      context 'when user is exist in db' do
        before do
          sign_in manage_users_user
          mock_delete_user
          mock_user_details
        end

        context 'when confirmation is yes' do
          before { subject }

          it 'redirects to the users page' do
            expect(subject).to redirect_to(users_path)
          end

          it 'sets :success flash message' do
            expect(flash[:success]).to eq('You have successfully removed John Doe from your account.')
          end
        end

        context 'when confirmation is no' do
          let(:confirmation) { 'no' }

          it 'redirects to the edit user page' do
            expect(subject).to redirect_to(edit_user_path(user_id))
          end
        end

        context 'when confirmation is nil' do
          let(:confirmation) { nil }

          before { subject }

          it 'render the view' do
            expect(response).to render_template(:remove)
          end

          it 'sets :alert flash message' do
            expect(flash[:alert]).to eq('Select yes to remove the user')
          end
        end
      end

      context 'when user is not exist in db' do
        before do
          sign_in manage_users_user
          allow(AccountsApi::Users).to receive(:delete_user)
            .and_raise(BaseApi::Error404Exception.new(404, '', {}))
        end

        it 'redirects to not_found page' do
          expect(subject).to redirect_to not_found_path
        end
      end
    end

    context 'without edit user data in session' do
      before { sign_in manage_users_user }

      it 'redirects to the users page' do
        expect(subject).to redirect_to users_path
      end
    end

    context 'when user want to delete his own account' do
      before { sign_in manage_users_user(user_id: user_id) }

      it 'redirects to the users page' do
        expect(subject).to redirect_to users_path
      end
    end
  end

  it_behaves_like 'incorrect permissions'
  it_behaves_like 'a login required'
end
