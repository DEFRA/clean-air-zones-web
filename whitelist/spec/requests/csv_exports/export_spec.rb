# frozen_string_literal: true

require 'rails_helper'

describe 'CsvExportsController - GET #export', type: :request do
  subject { get export_vehicles_path }

  before do
    sign_in new_user
    subject
  end

  it 'returns a success response' do
    expect(response).to have_http_status(:success)
  end

  it 'renders the view' do
    expect(response).to render_template(:export)
  end
end
