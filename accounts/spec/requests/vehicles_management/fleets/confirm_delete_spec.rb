# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesManagement::FleetsController - POST #confirm_delete' do
  subject { post delete_fleets_path, params: { 'confirm-delete': confirmation } }

  let(:confirmation) { 'yes' }

  context 'correct permissions' do
    let(:fleet) { create_fleet }

    it 'redirects to the login page' do
      subject
      expect(response).to redirect_to(new_user_session_path)
    end

    context 'when user is logged in' do
      before do
        sign_in manage_vehicles_user
        mock_fleet(fleet)
      end

      it 'redirects to fleets' do
        subject
        expect(response).to redirect_to(fleets_path)
      end

      context 'with VRN in the session' do
        before { add_to_session(vrn: @vrn) }

        context 'when user confirms subject' do
          it 'calls VehiclesManagement::Fleet#delete_vehicle' do
            expect(fleet).to receive(:delete_vehicle).with(@vrn)
            subject
          end

          context do
            before { subject }

            it 'redirects to the fleets page' do
              expect(response).to redirect_to(fleets_path)
            end

            it 'clears vrn in the session' do
              expect(session[:vrn]).to eq(nil)
            end

            it 'sets :success notification in flash' do
              expect(flash[:success]).to eq('You have successfully removed ABC123 from your vehicle list.')
            end
          end

          context 'when it was the last vehicle' do
            before { mock_fleet(create_empty_fleet) }

            it 'redirects to the dashboard' do
              subject
              expect(response).to redirect_to(dashboard_path)
            end
          end
        end

        context 'when user does not confirm details' do
          let(:confirmation) { 'no' }

          it 'redirects to the fleets page' do
            subject
            expect(response).to redirect_to(fleets_path)
          end

          it 'does not call VehiclesManagement::Fleet#delete_vehicle' do
            expect(fleet).not_to receive(:delete_vehicle)
            subject
          end
        end

        context 'when confirmation is empty' do
          let(:confirmation) { '' }

          before { subject }

          it 'redirects to the delete' do
            expect(response).to redirect_to(delete_fleets_path)
          end

          it 'flashes a right alert' do
            expect(flash[:alert]).to eq(I18n.t('confirmation_form.answer_missing'))
          end
        end
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
