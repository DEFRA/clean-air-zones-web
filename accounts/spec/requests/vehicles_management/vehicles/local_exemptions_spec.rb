# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesManagement::VehicleController - GET #local_exemptions' do
  subject { get local_exemptions_vehicles_path }

  context 'correct permissions' do
    before { sign_in manage_vehicles_user }

    it 'renders the view' do
      expect(subject).to render_template(:local_exemptions)
    end
  end

  it_behaves_like 'incorrect permissions'
  it_behaves_like 'a login required'
end
