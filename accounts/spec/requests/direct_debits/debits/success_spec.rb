# frozen_string_literal: true

require 'rails_helper'

describe 'DirectDebits::DebitsController - GET #success' do
  subject { get success_debits_path }

  context 'correct permissions' do
    before do
      mock_clean_air_zones
      add_to_session(initiated_payment: {
                       caz_id: caz_id,
                       payment_id: 'gr4q4tedct2vqqo39uvb2o1ei4',
                       details: details
                     })
      sign_in user
    end

    let(:user) { make_payments_user }
    let(:caz_id) { @uuid }

    let(:details) do
      {
        'CU12345' =>
        {
          'vrn' => 'CU12345',
          'tariff' => 'BCC01-HEAVY GOODS VEHICLE',
          'charge' => 50.0,
          'dates' => ['2020-03-26']
        }
      }
    end

    it 'renders the view' do
      expect(subject).to render_template(:success)
    end

    context 'when CAZ locked by current user' do
      before do
        add_caz_lock_to_redis(user)
        subject
      end

      it 'removes caz lock from redis' do
        expect(REDIS.hget(caz_lock_redis_key, 'caz_id')).to be_nil
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
