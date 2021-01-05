# frozen_string_literal: true

require 'rails_helper'

describe 'AccountsApi::Accounts.create_account - POST' do
  subject { AccountsApi::Accounts.create_account(company_name: name) }

  let(:name) { 'Awesome Inc.' }

  context 'when the response status is 201' do
    before do
      user_details = read_unparsed_response('create_account.json')
      stub_request(:post, /accounts/).to_return(
        status: 201,
        body: user_details
      )
    end

    it 'returns a proper fields' do
      expect(subject.keys).to contain_exactly('accountId')
    end

    it 'calls API with proper body' do
      body = { accountName: name }
      subject
      expect(WebMock).to have_requested(:post, /accounts/).with(body: body).once
    end
  end

  context 'when the response status is 422' do
    before do
      stub_request(:post, /accounts/).to_return(
        status: 422,
        body: {
          message: 'Creation failed',
          'details' => %w[emailNotUnique passwordNotValid]
        }.to_json
      )
    end

    it 'raises Error422Exception' do
      expect { subject }.to raise_exception(BaseApi::Error422Exception)
    end
  end
end
