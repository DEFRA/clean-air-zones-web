# frozen_string_literal: true

require 'rails_helper'

describe 'AccountsApi::Auth.validate_password_reset - PUT' do
  subject { AccountsApi::Auth.set_password(token: token, password: password) }

  let(:token) { SecureRandom.uuid }
  let(:password) { 'password' }
  let(:url) { %r{auth/password/set} }

  before do
    stub_request(:put, url).to_return(
      status: 204,
      body: nil
    )
  end

  it 'calls API with proper body' do
    subject
    expect(WebMock)
      .to have_requested(:put, url)
      .with(body: { token: token, password: password })
      .once
  end

  it 'returns true' do
    expect(subject).to be_truthy
  end
end
