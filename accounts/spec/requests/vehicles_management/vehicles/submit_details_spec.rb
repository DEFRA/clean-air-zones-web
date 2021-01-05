# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesManagement::VehicleController - POST #submit_details' do
  subject { post enter_details_vehicles_path, params: { vrn: vrn } }

  let(:vrn) { @vrn }

  context 'correct permissions' do
    it 'redirects to the login page' do
      subject
      expect(response).to redirect_to(new_user_session_path)
    end

    context 'when user is logged in' do
      before do
        sign_in manage_vehicles_user
        subject
      end

      context 'when VrnForm is valid' do
        it 'redirects to the vehicles details page' do
          expect(response).to redirect_to(details_vehicles_path)
        end

        it 'sets vrn in the session' do
          expect(session[:vrn]).to eq(vrn)
        end
      end

      context 'when VrnForm is NOT valid' do
        let(:vrn) { nil }

        it 'redirects to the enter details page' do
          expect(response).to render_template(:enter_details)
        end

        it 'assigns @errors' do
          expect(assigns(:errors)).not_to be_nil
        end

        it 'does not set vrn in the session' do
          expect(session[:vrn]).to be_nil
        end
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
