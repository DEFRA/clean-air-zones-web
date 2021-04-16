# frozen_string_literal: true

require 'rails_helper'

describe 'Organisations::OrganisationsController - GET #email_verification', type: :request do
  subject { get email_verification_organisations_path(token: token) }

  let(:token) { 'token' }

  before { allow(Organisations::VerifyAccount).to receive(:call).and_return(:success) }

  it 'returns a redirect to :email_verified' do
    subject
    expect(response).to redirect_to(email_verified_organisations_path)
  end

  it 'calls Organisations::VerifyAccount with proper params' do
    subject
    expect(Organisations::VerifyAccount).to have_received(:call).with(token: token)
  end

  context 'when verification is invalid' do
    before { allow(Organisations::VerifyAccount).to receive(:call).and_return(:invalid) }

    it 'returns a redirect to :verification_failed' do
      subject
      expect(response).to redirect_to(verification_failed_organisations_path)
    end
  end

  context 'when verification is expired' do
    before { allow(Organisations::VerifyAccount).to receive(:call).and_return(:expired) }

    it 'returns a redirect to :verification_expired' do
      subject
      expect(response).to redirect_to(verification_expired_organisations_path)
    end
  end

  context 'when verification is raised `UserAlreadyConfirmedException` exception' do
    before do
      allow(Organisations::VerifyAccount).to receive(:call).and_raise(UserAlreadyConfirmedException)
      subject
    end

    it 'renders the view' do
      expect(response).to render_template('devise/sessions/new')
    end

    it 'sets correct error to flash[:errors]' do
      expect(flash[:errors]).to eq({ base: ['User already confirmed'] })
    end
  end
end
