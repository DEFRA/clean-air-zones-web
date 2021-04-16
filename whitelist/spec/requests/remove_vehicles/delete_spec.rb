# frozen_string_literal: true

require 'rails_helper'

describe 'RemoveVehiclesController - POST #delete', type: :request do
  subject do
    post confirm_remove_vehicles_path,
         params: {
           confirm_remove_form: {
             confirmation: confirmation
           }
         }
  end

  let(:user_uuid) { SecureRandom.uuid }
  let(:user) { new_user(sub: user_uuid, preferred_username: user_uuid) }
  let(:confirmation) { 'yes' }

  before do
    sign_in user
  end

  context 'with `remove_vrn` in session' do
    before { add_to_session(remove_vrn: vrn) }

    context 'when confirmation is yes' do
      context 'and vrn exist in db' do
        before do
          allow(WhitelistApi).to receive(:delete_vrn)
            .with(vrn, user_uuid, user.email)
            .and_return(true)
          subject
        end

        it 'returns a found response' do
          expect(response).to have_http_status(:found)
        end

        it 'redirects to the remove vehicles page' do
          expect(response).to redirect_to(remove_vehicles_path)
        end

        it 'shows flash message' do
          expect(flash[:success]).to_not be_nil
        end
      end

      context 'when vrn not exist in db' do
        before do
          stub_request(:delete, /vehicles/).to_return(
            status: 404,
            body: { 'message' => 'VRN was not found' }.to_json
          )
          subject
        end

        it 'returns a found response' do
          expect(response).to have_http_status(:found)
        end

        it 'redirects to the remove vehicles page' do
          expect(response).to redirect_to(remove_vehicles_path)
        end

        it 'not shows a success message' do
          expect(flash[:success]).to be_nil
        end

        it 'shows a warning message' do
          expect(flash[:warning]).to_not be_nil
        end
      end
    end

    context 'when confirmation is no' do
      before do
        subject
      end

      let(:confirmation) { 'no' }

      it 'returns a found response' do
        expect(response).to have_http_status(:found)
      end

      it 'redirects to the remove vehicles page' do
        expect(response).to redirect_to(remove_vehicles_path)
      end

      it 'not shows a success message' do
        expect(flash[:success]).to be_nil
      end
    end

    context 'when confirmation is nil' do
      before do
        subject
      end

      let(:confirmation) { nil }

      it 'renders the view' do
        expect(response).to render_template(:confirm_remove)
      end
    end
  end

  context 'with no `remove_vrn` in session' do
    before do
      subject
    end

    it 'redirects to remove vehicle page' do
      subject
      expect(response).to redirect_to(remove_vehicles_path)
    end

    it 'not calls api' do
      expect(WhitelistApi).not_to receive(:delete_vrn)
    end
  end
end
