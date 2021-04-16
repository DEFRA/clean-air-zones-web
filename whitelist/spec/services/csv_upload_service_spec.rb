# frozen_string_literal: true

require 'rails_helper'

describe CsvUploadService do
  subject { described_class.call(file: file, user: user) }

  let(:user) { new_user }
  let(:file) { Rack::Test::UploadedFile.new(file_path) }
  let(:file_path) { File.join('spec', 'fixtures', 'files', 'csv', 'Whitelist-27-01-2020.csv') }

  describe '#call' do
    context 'with valid params' do
      before do
        allow_any_instance_of(Aws::S3::Object).to receive(:upload_file).and_return(true)
      end

      let(:filename) { "CCAZ_WhiteList_#{user.sub}::#{Time.current.to_i}.csv" }

      context 'lowercase extension format' do
        it 'returns the proper file name' do
          freeze_time do
            expect(subject).to eq(filename)
          end
        end
      end

      context 'uppercase extension format' do
        it 'returns the proper file name' do
          freeze_time do
            expect(subject).to eq(filename)
          end
        end
      end
    end

    context 'with invalid params' do
      context 'when `ValidateCsvService` returns error' do
        let(:file) { nil }

        it 'raises exception' do
          expect { subject }.to raise_exception(CsvUploadFailureException)
        end
      end

      context 'when `S3UploadService` returns error' do
        before do
          allow_any_instance_of(Aws::S3::Object).to receive(:upload_file).and_return(false)
        end

        it 'raises exception' do
          expect { subject }.to raise_exception(CsvUploadFailureException)
        end
      end

      context 'when S3 raises an exception' do
        before do
          allow_any_instance_of(Aws::S3::Object)
            .to receive(:upload_file)
            .and_raise(Aws::S3::Errors::MultipartUploadError.new('', ''))
        end

        it 'raises a proper exception' do
          expect { subject }.to raise_exception(CsvUploadFailureException)
        end
      end

      context 'when file is in the wrong format' do
        file = File.join('spec', 'fixtures', 'files', 'csv', 'empty', 'Whitelist-27-01-2020.xlsx')
        let(:file_path) { file }
        it 'raises exception' do
          expect { subject }.to raise_exception(CsvUploadFailureException)
        end
      end

      context 'when file size is too big' do
        let(:file_path) { File.join('spec', 'fixtures', 'files', 'csv', 'Whitelist-27-01-2020.csv') }

        before { allow(file).to receive(:size).and_return(52_428_801) }

        it 'raises exception' do
          expect { subject }.to raise_exception(CsvUploadFailureException)
        end
      end
    end
  end
end
