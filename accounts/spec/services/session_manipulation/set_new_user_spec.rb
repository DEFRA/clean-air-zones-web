# frozen_string_literal: true

require 'rails_helper'

describe SessionManipulation::SetNewUser do
  subject do
    described_class.call(session: session, params: { email: email, name: name })
  end

  let(:session) { {} }
  let(:email) { 'john.doe@example.com' }
  let(:name) { 'John Doe' }

  describe 'for email' do
    it 'sets new_user email in session' do
      subject
      expect(session[:new_user]['email']).to eq(email)
    end

    context 'when email contains whitespaces' do
      let(:email) { ' john.doe@example.com ' }

      it 'sets new_user email without whitespaces in session' do
        subject
        expect(session[:new_user]['email']).to eq(email.strip)
      end
    end
  end

  it 'sets new_user name in session' do
    subject
    expect(session[:new_user]['name']).to eq(name)
  end
end
