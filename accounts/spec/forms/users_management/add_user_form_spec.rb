# frozen_string_literal: true

require 'rails_helper'

describe UsersManagement::AddUserForm, type: :model do
  subject { described_class.new(account_id: account_id, new_user: new_user_data.stringify_keys) }

  let(:account_id) { create_user.account_id }
  let(:new_user_data) { { name: name, email: email } }
  let(:name) { 'New User Name' }
  let(:email) { 'New_user@Example.com' }

  describe 'valid?' do
    before { allow(AccountsApi::Accounts).to receive(:user_validations).and_return(true) }

    context 'when valid email format' do
      it { is_expected.to be_valid }

      context 'when all uppercase letters' do
        let(:email) { 'NEW_USER@EXAMPLE.COM' }

        it { is_expected.to be_valid }
      end

      context 'when uppercase letters only after @' do
        let(:email) { 'new_user@EXAMPLE.COM' }

        it { is_expected.to be_valid }
      end
    end

    context 'when name is empty' do
      let(:name) { '' }

      it { is_expected.not_to be_valid }

      it 'has a proper error message' do
        subject.valid?
        expect(subject.errors.messages[:name].join(',')).to include("Enter the user's name")
      end
    end

    context 'when invalid email format' do
      before { subject.valid? }

      context 'when email is empty' do
        let(:email) { '' }

        it { is_expected.not_to be_valid }

        it 'has a proper error message' do
          expect(subject_email_errors).to include("Enter the user's email address")
        end
      end

      context 'when email with comma' do
        let(:email) { 'test,a@test.com' }

        it { is_expected.not_to be_valid }

        it 'has a proper error message' do
          expect(subject_email_errors).to include('Enter the user’s email address in a valid format')
        end
      end

      context 'when email with two consecutive dots' do
        let(:email) { 'test..a@test.com ' }

        it { is_expected.not_to be_valid }

        it 'has a proper error message' do
          expect(subject_email_errors).to include('Enter the user’s email address in a valid format')
        end
      end

      context 'when email with dot at the end' do
        let(:email) { 'aaa.@test.com' }

        it { is_expected.not_to be_valid }

        it 'has a proper error message' do
          expect(subject_email_errors).to include('Enter the user’s email address in a valid format')
        end
      end
    end
  end

  describe '.email_not_duplicated' do
    before do
      allow(AccountsApi::Accounts).to receive(:user_invitations).and_return(true)
      allow(AccountsApi::Accounts).to receive(:user_validations).and_raise(
        BaseApi::Error400Exception.new(400, '', '')
      )
    end

    it { is_expected.not_to be_valid }

    it 'has a proper error message' do
      subject.valid?
      expect(subject.errors[:email]).to include('Email address already exists')
    end
  end
end

private

def subject_email_errors
  subject.errors.messages[:email].join(',')
end
