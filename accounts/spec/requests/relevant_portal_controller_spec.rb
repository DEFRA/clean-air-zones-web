# frozen_string_literal: true

require 'rails_helper'

describe RelevantPortalController, type: :request do
  describe 'GET #what_would_you_like_to_do' do
    subject { get what_would_you_like_to_do_path }

    it_behaves_like 'a static page'
  end

  describe 'POST #what_would_you_like_to_do' do
    subject { post what_would_you_like_to_do_path, params: { check_vehicle_option: check_vehicle_option } }

    before { subject }

    context 'with selected `single` option' do
      let(:check_vehicle_option) { 'single' }

      it 'returns a found response' do
        expect(response).to have_http_status(:found)
      end

      it 'redirects to VCCS UI' do
        expect(response).to(
          redirect_to("#{Rails.configuration.x.check_air_standard_url}/vehicle_checkers/enter_details")
        )
      end
    end

    context 'with selected `multiple` option' do
      let(:check_vehicle_option) { 'multiple' }

      it 'returns a found response' do
        expect(response).to have_http_status(:found)
      end

      it 'redirects to Fleets UI' do
        expect(response).to(redirect_to(root_path))
      end
    end

    context 'with selected `pay` option' do
      let(:check_vehicle_option) { 'pay' }

      it 'returns a found response' do
        expect(response).to have_http_status(:found)
      end

      it 'redirects to Payments UI' do
        expect(response).to(redirect_to("#{Rails.configuration.x.payments_ui_url}/vehicles/enter_details"))
      end
    end

    context 'with valid params' do
      let(:check_vehicle_option) { '' }

      it 'renders the form view' do
        expect(response).to render_template(:what_would_you_like_to_do)
      end
    end
  end
end
