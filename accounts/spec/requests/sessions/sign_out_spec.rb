# frozen_string_literal: true

require 'rails_helper'

describe 'SessionsController - DELETE #destroy', type: :request do
  subject { delete destroy_user_session_url }

  let(:user) { create_owner }
  let(:caz_id) { SecureRandom.uuid }

  before { add_caz_lock_to_redis(user) }

  context 'when CAZ locked by current user' do
    before do
      sign_in user
      add_to_session(new_payment: { caz_id: caz_id })
      subject
    end

    it 'redirects to the sign out page' do
      expect(response).to redirect_to(sign_out_path)
    end

    it 'removes caz lock from redis' do
      expect(REDIS.hget(caz_lock_redis_key, 'caz_id')).to be_nil
    end
  end

  context 'when CAZ locked by another user' do
    before do
      sign_in create_user(user_id: SecureRandom.uuid)
      subject
    end

    it 'redirects to the sign out page' do
      expect(response).to redirect_to(sign_out_path)
    end

    it 'not removes caz lock from redis' do
      expect(REDIS.hget(caz_lock_redis_key, 'caz_id')).not_to be_nil
    end
  end
end
