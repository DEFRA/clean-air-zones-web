# frozen_string_literal: true

require 'rails_helper'

describe 'AccountsApi::Auth.initiate_password_reset - POST' do
  subject { AccountsApi::Auth.initiate_password_reset(email: email, reset_url: reset_url) }

  let(:email) { 'test@example.com' }
  let(:url) { %r{auth/password/reset} }
  let(:reset_url) { 'http://wp.pl' }

  before do
    stub_request(:post, url).to_return(
      status: 204,
      body: nil
    )
  end

  it 'calls API with proper body' do
    subject
    expect(WebMock)
      .to have_requested(:post, url)
      .with(body: { email: email, resetUrl: reset_url })
      .once
  end

  it 'returns true' do
    expect(subject).to be_truthy
  end

  context 'when email has uppercased letters' do
    let(:email) { 'Test@Example.com' }

    it 'calls API with downcased email' do
      subject
      expect(WebMock)
        .to have_requested(:post, url)
        .with(body: { email: email.downcase, resetUrl: reset_url })
        .once
    end
  end
end
