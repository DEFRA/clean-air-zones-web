# frozen_string_literal: true

require 'rails_helper'

describe 'DirectDebits::DebitsController - GET #failure' do
  subject { get failure_debits_path }

  context 'correct permissions' do
    context 'and CAZ locked by current user' do
      before do
        add_caz_lock_to_redis(user)
        add_to_session(new_payment: { caz_id: caz_id })
        sign_in user
        subject
      end

      let(:user) { make_payments_user }
      let(:caz_id) { @uuid }

      it 'returns a 200 OK status' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders the view' do
        expect(subject).to render_template(:failure)
      end

      it 'removes caz lock from redis' do
        expect(REDIS.hget(caz_lock_redis_key, 'caz_id')).to be_nil
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
