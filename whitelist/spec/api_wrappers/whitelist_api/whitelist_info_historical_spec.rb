# frozen_string_literal: true

require 'rails_helper'

describe 'WhitelistApi.whitelist_info_historical' do
  subject do
    WhitelistApi.whitelist_info_historical(
      vrn: vrn,
      page: page,
      start_date: start_date,
      end_date: end_date
    )
  end

  let(:vrn) { 'CU57ABC' }
  let(:page) { 2 }
  let(:start_date) { '2010-01-01' }
  let(:end_date) { '2020-03-24' }

  context 'when call returns 200' do
    before do
      vrn_history = read_unparsed_file('whitelist_info_historical_response.json')
      stub_request(:get, /CU57ABC/).to_return(status: 200, body: vrn_history)
    end

    it 'calls API with proper query data' do
      subject
      expect(WebMock).to have_requested(
        :get,
        /endDate=#{end_date}&pageNumber=#{page - 1}&pageSize=10&startDate=#{start_date}/
      )
    end

    it 'returns proper fields' do
      expect(subject['1'].keys).to contain_exactly(
        'perPage',
        'page',
        'pageCount',
        'totalChangesCount',
        'changes'
      )
    end

    it 'returns proper `changes` fields' do
      expect(subject['1']['changes'].first.keys).to contain_exactly(
        'modifyDate',
        'action',
        'category',
        'manufacturer',
        'reasonUpdated',
        'uploaderEmail'
      )
    end

    it 'returns changes list' do
      expect(subject['1']['changes']).to be_a(Array)
    end
  end

  context 'when call returns 500' do
    before do
      stub_request(:get, /CU57ABC/).to_return(
        status: 500,
        body: { 'message' => 'Something went wrong' }.to_json
      )
    end

    it 'raises `Error500Exception`' do
      expect { subject }.to raise_exception(BaseApi::Error500Exception)
    end
  end

  context 'when call returns 400' do
    before do
      stub_request(:get, /CU57ABC/).to_return(
        status: 400,
        body: { 'message' => 'Correlation ID is missing' }.to_json
      )
    end

    it 'raises `Error400Exception`' do
      expect { subject }.to raise_exception(BaseApi::Error400Exception)
    end
  end

  context 'when call returns 404' do
    before do
      stub_request(:get, /CU57ABC/).to_return(
        status: 404,
        body: { 'message' => "Vehicle with registration number #{vrn} was not found" }.to_json
      )
    end

    it 'raises `Error404Exception`' do
      expect { subject }.to raise_exception(BaseApi::Error404Exception)
    end
  end

  context 'when call returns 422' do
    before do
      stub_request(:get, /CU57ABC/).to_return(
        status: 422,
        body: { 'message' => "#{vrn} is an invalid registration number" }.to_json
      )
    end

    it 'raises `Error422Exception`' do
      expect { subject }.to raise_exception(BaseApi::Error422Exception)
    end
  end
end
