# frozen_string_literal: true

require 'rails_helper'

describe 'DirectDebits::DebitsController - GET #cancel', type: :request do
  subject { get cancel_payments_path }

  context 'when correct permissions' do
    context 'with CAZ locked by current user' do
      before do
        add_to_session(new_payment: { caz_id: caz_id, details: {} })
        sign_in create_user
        subject
      end

      let(:user) { manage_mandates_user }
      let(:caz_id) { SecureRandom.uuid }

      it 'returns a 200 OK status' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders the cancel page' do
        expect(response).to render_template(:cancel)
      end

      it 'removes caz lock from redis' do
        expect(REDIS.hget(caz_lock_redis_key, 'caz_id')).to be_nil
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
