# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesController - POST #create', type: :request do
  subject do
    post add_vehicles_path, params: { new_vrn_form:
           {
             vrn: vrn,
             category: category,
             manufacturer: manufacturer,
             reason: reason
           } }
  end

  let(:vrn) { 'CU57ABC' }
  let(:category) { 'Other' }
  let(:manufacturer) { 'ZAZ' }
  let(:reason) { 'Testing' }

  before do
    sign_in new_user
  end

  context 'when vrn not exists in db' do
    before do
      response = read_file('update_vrn_response.json')
      allow(WhitelistApi).to receive(:add_vrn).and_return(response)
      subject
    end

    context 'when VRN is valid' do
      it 'returns a found response' do
        expect(response).to have_http_status(:found)
      end
    end

    context 'when VRN is not valid' do
      let(:vrn) { '' }

      it 'renders add a new vrn page' do
        expect(response).to render_template(:add)
      end
    end

    context 'when category is not valid' do
      let(:category) { '' }

      it 'renders add a new vrn page' do
        expect(response).to render_template(:add)
      end
    end

    context 'when reason is not valid' do
      let(:reason) { '' }

      it 'renders add a new vrn page' do
        expect(response).to render_template(:add)
      end
    end

    context 'when VRN has whitespaces' do
      let(:vrn) { ' A B C ' }

      it 'returns a found response' do
        expect(response).to have_http_status(:found)
      end

      it 'redirects to add vehicle page' do
        expect(response).to redirect_to(add_vehicles_path)
      end
    end
  end

  context 'when vrn already exists in db' do
    before do
      service = BaseApi::Error422Exception
      allow(WhitelistApi).to receive(:add_vrn).and_raise(
        service.new(422, 'VRN is already Whitelisted', {})
      )
      subject
    end

    it 'renders add a new vrn page' do
      expect(response).to render_template(:add)
    end
  end
end
