# frozen_string_literal: true

require 'rails_helper'

describe Cognito::GetUser do
  subject { described_class.call(access_token: token, username: username) }

  let(:token) { 'a651dc86-2c3f-4ba2-8b1e-c23b5cdeb59a' }
  let(:cognito_response) do
    OpenStruct.new(username: username, user_attributes: [
                     OpenStruct.new(name: 'email', value: email),
                     OpenStruct.new(name: 'preferred_username', value: preferred_username),
                     OpenStruct.new(name: 'sub', value: sub)
                   ])
  end
  let(:email) { 'test@example.com' }
  let(:username) { 'wojtek@example.com' }
  let(:sub) { 'a651dc86-2c3f-4ba2-8b1e-c23b5cdeb59a' }
  let(:preferred_username) { SecureRandom.uuid }

  before do
    allow(Cognito::Client.instance).to receive(:get_user)
      .with(access_token: token)
      .and_return(cognito_response)
    allow(Cognito::UpdatePreferredUsername).to receive(:call).and_return(true)
  end

  it 'returns an instance of the user class' do
    expect(subject).to be_a(User)
  end

  it 'sets user email' do
    expect(subject.email).to eq(email)
  end

  it 'sets username' do
    expect(subject.username).to eq(username)
  end

  it 'sets aws_status to OK' do
    expect(subject.aws_status).to eq('OK')
  end

  it 'sets aws_session to nil' do
    expect(subject.aws_session).to eq(nil)
  end

  it 'sets sub' do
    expect(subject.sub).to eq(sub)
  end

  it 'calls Cognito::UpdatePreferredUsername service' do
    subject
    expect(Cognito::UpdatePreferredUsername).to have_received(:call)
  end

  describe '.preferred_username' do
    context 'when preferred_username not nil' do
      it 'returns a proper value' do
        expect(subject.preferred_username).to eq(preferred_username)
      end
    end

    context 'when preferred_username is nil' do
      let(:preferred_username) { nil }

      it 'returns a proper value' do
        expect(subject.preferred_username).to eq(sub)
      end
    end
  end

  context 'when the initial user is given' do
    subject do
      described_class.call(access_token: token, username: username, user: user)
    end

    let(:user) { User.new(login_ip: remote_ip) }
    let(:remote_ip) { '1.2.3.4' }

    it 'does not override login_ip' do
      expect(subject.login_ip).to eq(remote_ip)
    end
  end
end
