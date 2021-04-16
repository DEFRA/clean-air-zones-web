# frozen_string_literal: true

require 'rails_helper'

describe 'UsersManagement::RemoveUsersController - GET #remove', type: :request do
  subject { get remove_user_path(user_id) }

  let(:user_id) { SecureRandom.uuid }

  context 'when correct permissions' do
    context 'with edit user data in session' do
      before { add_to_session(edit_user: { name: 'John Doe' }) }

      context 'when user exists in the db' do
        before do
          sign_in manage_users_user
          mock_user_details
          allow(UsersManagement::IsDirectDebitCreator).to receive(:call).and_return(is_creator)
          allow(UsersManagement::EmailFetcher).to receive(:new).and_return(
            instance_double('UsersManagement::EmailFetcher',
                            for_account_user: 'user@email.com',
                            for_owner: 'owner@email.com')
          )
        end

        context 'when user is a mandate creator' do
          let(:is_creator) { true }

          it 'assigns @is_mandate_creator variable' do
            subject
            expect(assigns(:is_mandate_creator)).to eq true
          end

          it 'assigns @user_email variable' do
            subject
            expect(assigns(:user_email)).to eq 'user@email.com'
          end

          it 'assigns @owner_email variable' do
            subject
            expect(assigns(:owner_email)).to eq 'owner@email.com'
          end

          it 'renders the view' do
            expect(subject).to render_template(:remove)
          end
        end

        context 'when user is not a mandate creator' do
          let(:is_creator) { false }

          it 'assigns @is_mandate_creator variable' do
            subject
            expect(assigns(:is_mandate_creator)).to eq false
          end

          it 'does not assign @user_email variable' do
            subject
            expect(assigns(:user_email)).to eq nil
          end

          it 'does not assign @owner_email variable' do
            subject
            expect(assigns(:owner_email)).to eq nil
          end

          it 'renders the view' do
            expect(subject).to render_template(:remove)
          end
        end
      end

      context 'when user want to delete his own account' do
        before { sign_in manage_users_user(user_id: user_id) }

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
