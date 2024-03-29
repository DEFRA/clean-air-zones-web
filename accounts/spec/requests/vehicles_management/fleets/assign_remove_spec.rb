# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesManagement::FleetsController - GET #assign_delete', type: :request do
  subject { get assign_remove_fleets_path(vrn: vrn) }

  let(:vrn) { mocked_vrn }

  context 'when correct permissions' do
    it 'redirects to the login page' do
      subject
      expect(response).to redirect_to(new_user_session_path)
    end

    context 'when user is logged in' do
      before do
        sign_in manage_vehicles_user
        subject
      end

      context 'when vrn is given' do
        it 'redirects to #remove' do
          expect(response).to redirect_to(remove_fleets_path)
        end

        it 'sets vrn in the session' do
          expect(session[:vrn]).to eq(vrn)
        end
      end

      context 'when vrn is NOT given' do
        let(:vrn) { nil }

        it 'redirects to #index' do
          expect(response).to redirect_to(fleets_path)
        end
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
