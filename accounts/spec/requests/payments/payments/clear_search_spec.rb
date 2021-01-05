# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentsController - GET #clear_serach' do
  subject { get clear_search_payments_path }

  context 'correct permissions' do
    before do
      mock_clean_air_zones
      mock_fleet(create_chargeable_vehicles)
      sign_in create_user
      add_to_session(new_payment: { caz_id: @uuid })
      add_to_session(payment_query: { search: 'search' })
    end

    it 'clears search value' do
      subject
      expect(assigns(:search)).to be_nil
    end

    it 'redirects to the matrix' do
      subject
      expect(response).to redirect_to(matrix_payments_path)
    end
  end

  it_behaves_like 'incorrect permissions'
end
