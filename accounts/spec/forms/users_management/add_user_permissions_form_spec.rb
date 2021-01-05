# frozen_string_literal: true

require 'rails_helper'

describe UsersManagement::AddUserPermissionsForm, type: :model do
  subject do
    described_class.new(
      current_user: user,
      new_user: new_user_data.stringify_keys,
      verification_url: verification_url
    )
  end

  let(:user) { create_user }
  let(:new_user_data) do
    {
      'name': 'New User Name',
      'email': 'new_user@example.com',
      'permissions': permissions
    }
  end
  let(:verification_url) { 'http://www.example.com/users/set_up' }
  let(:permissions) { ['MANAGE_USERS'] }

  describe 'valid?' do
    before { allow(AccountsApi::Accounts).to receive(:user_validations).and_return(true) }

    it { is_expected.to be_valid }

    context 'empty permissions' do
      let(:permissions) { [] }

      it { is_expected.not_to be_valid }

      it 'has a proper error message' do
        subject.valid?
        expect(subject.errors.messages[:permissions].join(',')).to include(
          'Select at least one permission type to continue'
        )
      end
    end
  end

  describe '.submit' do
    before { allow(AccountsApi::Accounts).to receive(:user_invitations).and_return(true) }

    it 'returns true' do
      expect(subject.submit).to eq(true)
    end
  end

  describe '.email_not_duplicated' do
    before do
      allow(AccountsApi::Accounts).to receive(:user_invitations).and_return(true)
      allow(AccountsApi::Accounts).to receive(:user_validations).and_raise(
        BaseApi::Error400Exception.new(400, '', '')
      )
    end

    it 'returns false' do
      expect(subject.valid?).to eq(false)
    end

    it 'has a proper error message' do
      subject.valid?
      expect(subject.errors[:email]).to include('Email address already exists')
    end
  end
end
