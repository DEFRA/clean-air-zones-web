# frozen_string_literal: true

require 'rails_helper'

describe 'DirectDebits::DebitsController - GET #unsuccessful', type: :request do
  subject { get unsuccessful_debits_path }

  context 'when correct permissions' do
    context 'with CAZ locked by current user' do
      before do
        add_caz_lock_to_redis(user)
        add_to_session(new_payment: { caz_id: caz_id })
        sign_in user
        subject
      end

      let(:user) { make_payments_user }
      let(:caz_id) { SecureRandom.uuid }

      it 'returns a 200 OK status' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders the view' do
        expect(subject).to render_template(:unsuccessful)
      end

      it 'removes caz lock from redis' do
        expect(REDIS.hget(caz_lock_redis_key, 'caz_id')).to be_nil
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
