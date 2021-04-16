# frozen_string_literal: true

require 'rails_helper'

describe 'CsvExportsController - GET #download_csv', type: :request do
  subject { get download_csv_vehicles_path }

  before do
    allow(WhitelistApi).to receive(:csv_exports).and_return(read_file('csv_exports.json'))
    sign_in new_user
    subject
  end

  it 'returns a found response' do
    expect(response).to have_http_status(:found)
  end

  it 'redirects to file url' do
    expect(response.headers['Location']).to include('generated-file.csv')
  end
end
