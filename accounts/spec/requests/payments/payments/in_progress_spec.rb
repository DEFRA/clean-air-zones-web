# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentsController - GET #in_progress' do
  subject { get in_progress_payments_path }

  let(:caz_id) { @uuid }
  let(:account_id) { SecureRandom.uuid }
  let(:second_user_id) { SecureRandom.uuid }
  let(:user) { create_user(account_id: account_id, user_id: SecureRandom.uuid) }
  let(:second_user) { create_user(account_id: account_id, user_id: second_user_id) }

  context 'correct permissions' do
    let(:fleet) { create_chargeable_vehicles }

    before do
      sign_in user
      mock_clean_air_zones
      mock_fleet(fleet)
      add_to_session(new_payment: { caz_id: caz_id })
    end

    context 'with la in the session and with no CAZ lock' do
      before do
        add_caz_lock_to_redis(user)
        subject
      end

      it 'returns a 302 FOUND status' do
        expect(response).to have_http_status(:found)
      end

      it 'redirects to selected CAZ payment matrix' do
        expect(subject).to redirect_to(matrix_payments_path)
      end
    end

    context 'with la in the session and CAZ locked by other user' do
      before do
        sign_in second_user
        mock_second_user_details(account_id, user.user_id)
        add_caz_lock_to_redis(user)
        subject
      end

      it 'returns a 200 OK status' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'without la in the session' do
      before do
        add_to_session(new_payment: { caz_id: nil })
        subject
      end

      it 'redirects to the index' do
        expect(response).to redirect_to(payments_path)
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
