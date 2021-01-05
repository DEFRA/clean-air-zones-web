# frozen_string_literal: true

require 'rails_helper'

describe 'AccountsApi::Users.update_user - PATCH' do
  subject do
    AccountsApi::Users.update_user(
      account_id: account_id,
      account_user_id: account_user_id,
      permissions: permissions,
      name: name
    )
  end

  let(:account_id) { '3fa85f64-5717-4562-b3fc-2c963f66afa6' }
  let(:account_user_id) { 'f1409c5e-3241-44b8-8224-8d40ee0fcac6' }
  let(:permissions) { %w[MANAGE_VEHICLES MANAGE_USERS] }
  let(:name) { 'Carl Glasser' }
  let(:url) { "/accounts/#{account_id}/users/#{account_user_id}" }

  context 'when the response status is 200' do
    before { stub_request(:patch, /#{url}/).to_return(status: 200) }

    it 'calls API with proper body' do
      subject
      expect(WebMock).to have_requested(:patch, /#{url}/)
        .with(body: { permissions: permissions, name: name })
        .once
    end

    context 'when name parameter is missing' do
      let(:permissions) { nil }

      it 'calls API with only name parameter' do
        subject
        expect(WebMock).to have_requested(:patch, /#{url}/).with(body: { name: name }).once
      end
    end

    context 'when permissions parameter is missing' do
      let(:name) { nil }

      it 'calls API with only permissions parameter' do
        subject
        expect(WebMock).to have_requested(:patch, /#{url}/).with(body: { permissions: permissions }).once
      end
    end
  end

  context 'when the response status is 404' do
    before do
      stub_request(:patch, /#{url}/).to_return(
        status: 404,
        body: { message: 'Account or user not found' }.to_json
      )
    end

    it 'raises Error404Exception' do
      expect { subject }.to raise_exception(BaseApi::Error404Exception)
    end
  end

  context 'when the response status is 500' do
    before do
      stub_request(:patch, /#{url}/).to_return(
        status: 500,
        body: { message: 'Something went wrong' }.to_json
      )
    end

    it 'raises Error500Exception' do
      expect { subject }.to raise_exception(BaseApi::Error500Exception)
    end
  end
end
