# frozen_string_literal: true

require 'rails_helper'

describe DashboardController, type: :request do
  describe 'GET #index' do
    subject { get dashboard_path }

    it 'redirects to the login page' do
      subject
      expect(response).to redirect_to(new_user_session_path)
    end

    context 'when user is signed in' do
      before do
        mock_fleet
        mock_users
        mock_debits
        mock_actual_account_name
        mock_clean_air_zones
        mock_payment_history
        sign_in user
      end

      let(:user) do
        create_user(
          permissions: %w[MAKE_PAYMENTS MANAGE_MANDATES MANAGE_VEHICLES MANAGE_USERS],
          beta_tester: beta_tester
        )
      end
      let(:beta_tester) { false }

      context 'with user is not in a beta group' do
        context 'with Direct Debits feature enabled' do
          before do
            mock_direct_debit_enabled
            subject
          end

          it 'clears the session' do
            expect(session[:new_user]).to be_nil
          end

          it 'assigns :mandates_present variable' do
            expect(assigns(:mandates_present)).to be_truthy
          end
        end

        context 'with Direct Debits feature disabled' do
          before do
            mock_direct_debit_disabled
            subject
          end

          it 'clears the session' do
            expect(session[:new_user]).to be_nil
          end

          it 'assigns :mandates_present variable' do
            expect(assigns(:mandates_present)).to be_falsey
          end
        end
      end

      context 'with user is in a beta group and with Direct Debits feature disabled' do
        let(:beta_tester) { true }

        before do
          mock_direct_debit_disabled
          add_to_session(new_user: { name: user.account_name, email: user.email })
          subject
        end

        it 'clears the session' do
          expect(session[:new_user]).to be_nil
        end

        it 'assigns :mandates_present variable' do
          expect(assigns(:mandates_present)).to be_truthy
        end
      end

      context 'when CAZ locked by current user' do
        before do
          add_caz_lock_to_redis(user)
          add_to_session(new_payment: { caz_id: caz_id })
          subject
        end

        let(:caz_id) { SecureRandom.uuid }

        it 'removes caz lock from redis' do
          expect(REDIS.hget(caz_lock_redis_key, 'caz_id')).to be_nil
        end
      end
    end

    context 'when user is signed in with password that is about to expire in 8 days' do
      before do
        mock_fleet
        mock_users
        mock_actual_account_name
        mock_clean_air_zones
        mock_debits
        mock_payment_history
        sign_in create_user(permissions: [], days_to_password_expiry: 8)
        subject
      end

      it 'returns a 200 OK status' do
        expect(response).to have_http_status(:ok)
      end

      it 'assigns @days_count variable' do
        expect(assigns(:days_count)).to eq(8)
      end
    end

    context 'when user is signed in with VIEW_PAYMENTS permissions' do
      context 'with already made payments' do
        before do
          mock_fleet
          mock_users
          mock_actual_account_name
          mock_clean_air_zones
          mock_payment_history
          mock_debits
          sign_in create_user(permissions: ['VIEW_PAYMENTS'], days_to_password_expiry: 8)
          subject
        end

        it 'assigns @payments_present variable' do
          expect(assigns(:payments_present)).to eq(true)
        end
      end

      context 'without not made any payments' do
        before do
          mock_fleet
          mock_users
          mock_actual_account_name
          mock_clean_air_zones
          mock_debits
          mock_empty_payment_history
          sign_in create_user(permissions: ['VIEW_PAYMENTS'], days_to_password_expiry: 8)
          subject
        end

        it 'assigns @payments_present variable' do
          expect(assigns(:payments_present)).to eq(false)
        end
      end
    end

    context 'when user is signed in with MAKE_PAYMENTS permissions' do
      context 'with already made payments' do
        before do
          mock_fleet
          mock_users
          mock_actual_account_name
          mock_clean_air_zones
          mock_payment_history
          mock_debits
          sign_in create_user(permissions: ['MAKE_PAYMENTS'], days_to_password_expiry: 8)
          subject
        end

        it 'assigns @payments_present variable' do
          expect(assigns(:payments_present)).to eq(true)
        end
      end

      context 'without not made any payments' do
        before do
          mock_fleet
          mock_users
          mock_actual_account_name
          mock_clean_air_zones
          mock_empty_payment_history
          mock_debits
          sign_in create_user(permissions: ['MAKE_PAYMENTS'], days_to_password_expiry: 8)
          subject
        end

        it 'assigns @payments_present variable' do
          expect(assigns(:payments_present)).to eq(false)
        end
      end
    end

    context 'when user enters the Dashboard with an outdated password' do
      before { sign_in create_user(permissions: [], days_to_password_expiry: -2) }

      it 'redirects to the edit password page' do
        subject
        expect(response).to redirect_to(edit_passwords_path)
      end
    end

    context 'when user login IP does not match request IP' do
      before do
        sign_in create_user(login_ip: '0.0.0.0')
        subject
      end

      it 'returns a redirect to login page' do
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'logs out the user' do
        expect(controller.current_user).to be_nil
      end
    end
  end
end
