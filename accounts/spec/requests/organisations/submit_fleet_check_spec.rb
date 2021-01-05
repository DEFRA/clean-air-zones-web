# frozen_string_literal: true

require 'rails_helper'

describe 'Organisations::OrganisationsController - POST #submit_fleet_check' do
  subject do
    post fleet_check_organisations_path, params: {
      organisations: { confirm_fleet_check: 'less_than_two' }
    }
  end

  context 'with valid params' do
    before do
      allow(Organisations::ValidateFleetCheck).to receive(:call).and_return(@uuid)
      subject
    end

    it 'returns a success response' do
      expect(response).to have_http_status(:found)
    end
  end

  context 'with invalid params' do
    let(:errors) { { company_name: 'Sample Error' } }

    before do
      allow(Organisations::ValidateFleetCheck).to(receive(:call)
        .and_raise(InvalidFleetCheckException, errors))
      subject
    end

    it 'renders the create company name view' do
      expect(response).to render_template(:fleet_check)
    end
  end

  context 'when service throw AccountForMultipleVehiclesException exception' do
    let(:errors) { { company_name: 'Sample Error' } }

    before do
      allow(Organisations::ValidateFleetCheck).to(receive(:call)
        .and_raise(AccountForMultipleVehiclesException, errors))
      subject
    end

    it 'renders the create company name view' do
      expect(response).to redirect_to(cannot_create_organisations_path)
    end
  end
end
