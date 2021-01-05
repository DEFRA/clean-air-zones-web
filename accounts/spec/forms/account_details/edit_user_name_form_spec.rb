# frozen_string_literal: true

require 'rails_helper'

describe AccountDetails::EditUserNameForm, type: :model do
  subject { described_class.new(name: name) }

  before { subject.valid? }

  context 'when name is present' do
    let(:name) { 'present-name' }

    it { is_expected.to be_valid }
  end

  context 'when name is blank' do
    let(:name) { '' }

    it { is_expected.not_to be_valid }

    it 'has a proper error message' do
      expect(subject.errors.messages[:name]).to(
        include(I18n.t('edit_user_name_form.errors.name_missing'))
      )
    end
  end
end
