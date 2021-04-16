# frozen_string_literal: true

require 'rails_helper'

describe 'UploadController - GET #import', type: :request do
  subject { post import_upload_index_path, params: { file: csv_file } }

  let(:file_path) do
    File.join(
      'spec',
      'fixtures', 'files', 'csv', 'Whitelist-27-01-2020.csv'
    )
  end
  let(:csv_file) { Rack::Test::UploadedFile.new(file_path) }
  let(:user) { new_user }
  let(:filename) { "CCAZ_WhiteList_#{user.sub}::#{Time.current.to_i}.csv" }

  before { sign_in user }

  context 'with valid params' do
    let(:job_name) { '20200124_154821_CSV_FROM_S3_FILENAME' }

    before { allow(CsvUploadService).to receive(:call).and_return(filename) }

    context 'and api returns 200 status' do
      before do
        allow(RegisterCheckerApi).to receive(:register_job).and_return(job_name)
        subject
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:found)
      end

      it 'sets job name in session' do
        expect(session[:job][:name]).to eq(job_name)
      end

      it 'sets filename in session' do
        expect(session[:job][:filename]).to eq(filename)
      end
    end

    context 'and api returns 400 status' do
      before do
        allow(RegisterCheckerApi).to receive(:register_job).and_raise(
          BaseApi::Error400Exception.new(400, '', {})
        )
      end

      it 'renders the service unavailable page' do
        expect(subject).to render_template('errors/service_unavailable')
      end
    end
  end

  context 'with invalid params' do
    let(:file_path) do
      File.join('spec',
                'fixtures', 'files', 'csv', 'empty', 'Whitelist-27-01-2020.xlsx')
    end

    it 'returns error' do
      subject
      follow_redirect!
      expect(response.body).to include('The selected file must be a CSV')
    end
  end
end
