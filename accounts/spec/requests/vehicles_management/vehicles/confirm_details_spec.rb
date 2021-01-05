# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesManagement::VehicleController - POST #confirm_details' do
  subject { post confirm_details_vehicles_path, params: { 'confirm-vehicle' => confirmation } }

  let(:confirmation) { 'yes' }

  context 'correct permissions' do
    let(:account_id) { @uuid }

    it 'redirects to the login page' do
      subject
      expect(response).to redirect_to(new_user_session_path)
    end

    context 'when user is signed in' do
      before { sign_in manage_vehicles_user(account_id: account_id) }

      context 'without VRN in the session' do
        it 'redirects to vehicles#enter_details' do
          subject
          expect(response).to redirect_to(enter_details_vehicles_path)
        end
      end

      context 'with VRN in the session' do
        before do
          allow(FleetsApi).to receive(:add_vehicle_to_fleet).and_return(true)
          add_to_session(vrn: @vrn)
        end

        context 'when user confirms details' do
          it 'redirects to the local vehicle exemptions' do
            subject
            expect(response).to redirect_to(local_exemptions_vehicles_path)
          end
        end

        context 'when user does not confirm details' do
          let(:confirmation) { 'no' }

          it 'redirects to the incorrect details page' do
            subject
            expect(response).to redirect_to(incorrect_details_vehicles_path)
          end
        end

        context 'when confirmation is empty' do
          let(:confirmation) { '' }

          it 'redirects to the confirm details page' do
            subject
            expect(response).to redirect_to(details_vehicles_path)
          end
        end
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
