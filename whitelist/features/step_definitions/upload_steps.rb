# frozen_string_literal: true

def correlation_id
  '2458c8d6-9553-4687-9e13-cad47e7e458d'
end

def job_name
  '20200124_154821_CSV_FROM_S3_FILENAME'
end

When('I upload a valid csv file') do
  allow(SecureRandom).to receive(:uuid).and_return(correlation_id)
  filename = 'CCAZ_WhiteList_fb39da4f-a2dc-46fd-921c-74a7abde5745::1579868795'
  allow(CsvUploadService).to receive(:call).and_return(filename)
  allow(RegisterCheckerApi).to receive(:register_job).with(filename, correlation_id)
                                                     .and_return(job_name)

  allow(RegisterCheckerApi).to receive(:job_status)
    .with(job_name, correlation_id).and_return('RUNNING')

  attach_file(:file, csv_file('Whitelist-27-01-2020.csv'))
  click_button 'Upload'
end

When('I upload a valid csv file when API server is unavailable') do
  allow(SecureRandom).to receive(:uuid).and_return(correlation_id)
  filename = 'CCAZ_WhiteList_fb39da4f-a2dc-46fd-921c-74a7abde5745::1579868795'
  allow(CsvUploadService).to receive(:call).and_return(filename)
  allow(RegisterCheckerApi).to receive(:register_job).with(filename, correlation_id)
                                                     .and_raise(Errno::ECONNREFUSED)

  attach_file(:file, csv_file('Whitelist-27-01-2020.csv'))
  click_button 'Upload'
end

When('I press refresh page link') do
  allow(RegisterCheckerApi).to receive(:job_status)
    .with(job_name, correlation_id).and_return('SUCCESS')

  click_link 'click here.'
end

When('I press refresh page link when api response not running or finished') do
  allow(RegisterCheckerApi).to receive(:job_status)
    .with(job_name, correlation_id).and_return('FAILURE')
  allow(RegisterCheckerApi).to receive(:job_errors)
    .with(job_name, correlation_id).and_return(%w[error])
  click_link 'click here.'
end

When('I upload a csv file whose format that is not .csv or .CSV') do
  attach_file(:file, empty_csv_file('Whitelist-27-01-2020.xlsx'))
  click_button 'Upload'
end

When('I upload a csv file whose size is too big') do
  attach_file(:file, csv_file('Whitelist-27-01-2020.csv'))
  allow_any_instance_of(ActionDispatch::Http::UploadedFile).to receive(:size)
    .and_return(52_428_801)
  click_button 'Upload'
end

When('I upload a csv file during error on S3') do
  allow_any_instance_of(Aws::S3::Object).to receive(:upload_file).and_return(false)

  attach_file(:file, csv_file('Whitelist-27-01-2020.csv'))
  click_button 'Upload'
end

When('I want go to processing page') do
  visit processing_upload_index_path
end

Then('I change my IP') do
  allow_any_instance_of(ActionDispatch::Request)
    .to receive(:remote_ip)
    .and_return('4.3.2.1')
end

private

def empty_csv_file(filename)
  File.join('spec', 'fixtures', 'files', 'csv', 'empty', filename)
end

def csv_file(filename)
  File.join('spec', 'fixtures', 'files', 'csv', filename)
end
