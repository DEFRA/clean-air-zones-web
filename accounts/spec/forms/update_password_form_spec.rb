# frozen_string_literal: true

require 'rails_helper'

describe UpdatePasswordForm, type: :model do
  subject do
    described_class.new(user_id: user_id,
                        old_password: old_password,
                        password: password,
                        password_confirmation: password_confirmation)
  end

  let(:user_id) { SecureRandom.uuid }
  let(:old_password) { 'old_password12345!' }
  let(:password) { 'new_password12345!' }
  let(:password_confirmation) { 'new_password12345!' }

  before { subject.valid? }

  it 'is valid with a proper password' do
    expect(subject).to be_valid
  end

  context '.submit valid form' do
    before do
      allow(AccountsApi::Auth).to receive(:update_password).and_return(true)
      subject.submit
    end

    it 'calls AccountsApi with correct parameters' do
      body = { accountUserId: user_id, oldPassword: old_password, newPassword: password }
      allow(AccountsApi::Auth).to receive(:update_password).with(body: body).and_return(true)
    end
  end

  context 'when old password is empty' do
    let(:old_password) { '' }

    it 'is not valid' do
      expect(subject).not_to be_valid
    end

    it 'has a proper old password message' do
      expect(subject.errors[:old_password])
        .to include(I18n.t('update_password_form.errors.old_password_missing'))
    end
  end

  context 'when old password is invalid' do
    before do
      allow(AccountsApi::Auth).to receive(:update_password).and_raise(
        BaseApi::Error422Exception.new(422, '', 'errorCode' => 'oldPasswordInvalid')
      )
      subject.submit
    end

    it 'has a proper old password message' do
      expect(subject.errors[:old_password])
        .to include(I18n.t('update_password_form.errors.old_password_invalid'))
    end
  end

  context 'when new password is not complex enough' do
    before do
      allow(AccountsApi::Auth).to receive(:update_password).and_raise(
        BaseApi::Error422Exception.new(422, '', 'errorCode' => 'passwordNotValid')
      )
      subject.submit
    end

    it 'has a proper password message' do
      expect(subject.errors[:password]).to include(
        'Enter a password at least 12 characters long including at least 1 upper case letter, 1 number and '\
        'a special character'
      )
    end
  end

  context 'when old password is reused' do
    before do
      allow(AccountsApi::Auth).to receive(:update_password).and_raise(
        BaseApi::Error422Exception.new(422, '', 'errorCode' => 'newPasswordReuse')
      )
      subject.submit
    end

    it 'has a proper password message' do
      expect(subject.errors[:password]).to include(I18n.t('update_password_form.errors.password_reused'))
    end
  end

  context 'when api returns unknown errorCode' do
    before do
      allow(AccountsApi::Auth).to receive(:update_password).and_raise(
        BaseApi::Error422Exception.new(422, '', 'errorCode' => 'code')
      )
      subject.submit
    end

    it 'assigns a proper error message' do
      expect(subject.errors[:password])
        .to include('Something went wrong')
    end
  end
end
