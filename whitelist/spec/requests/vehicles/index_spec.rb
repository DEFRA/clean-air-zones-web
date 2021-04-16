# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesController - GET #index', type: :request do
  subject { get vehicles_path }

  let(:vrn) { 'CU57ABC' }

  before do
    sign_in new_user
  end

  context 'with VRN in the session' do
    before do
      response = read_file('vrn_details_response.json')
      allow(WhitelistApi).to receive(:vrn_details).with(vrn).and_return(response)
      add_to_session(vrn: vrn)
      subject
    end

    it 'returns ok status' do
      expect(response).to be_successful
    end

    it 'renders index page' do
      expect(response).to render_template(:index)
    end
  end

  context 'without VRN in the session' do
    before do
      subject
    end

    it_behaves_like 'vrn is missing'
  end

  context 'when VRN can not be found' do
    before do
      service = BaseApi::Error404Exception
      allow(WhitelistApi).to receive(:vrn_details).with(vrn).and_raise(
        service.new(404, 'VRN number was not found', {})
      )
      add_to_session(vrn: vrn)
      subject
    end

    it 'redirects to search vehicles path' do
      expect(response).to redirect_to(search_vehicles_path)
    end

    it 'shows flash message' do
      expect(flash[:warning]).to_not be_nil
    end
  end
end
