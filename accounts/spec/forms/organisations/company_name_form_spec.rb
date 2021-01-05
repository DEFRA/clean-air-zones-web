# frozen_string_literal: true

require 'rails_helper'

describe Organisations::CompanyNameForm, type: :model do
  subject { described_class.new(company_name_params) }

  let(:company_name_params) { { company_name: company_name } }
  let(:company_name) { 'Company name' }

  it { is_expected.to be_valid }

  context 'when company_name is empty' do
    let(:company_name) { '' }

    it { is_expected.not_to be_valid }

    it 'has a proper error message' do
      subject.valid?
      expect(subject.errors.messages[:company_name]).to(
        include(I18n.t('company_name_form.company_name_missing'))
      )
    end
  end

  context 'when company_name is too long' do
    let(:company_name) { '12345' * 37 }

    it { is_expected.not_to be_valid }

    it 'has a proper error message' do
      subject.valid?
      expect(subject.errors.messages[:company_name]).to include(
        I18n.t('company_name_form.company_name_invalid_length')
      )
    end
  end

  context 'when company name has valid format' do
    [
      'name with space',
      'UPPER CASES with 12 numbers',
      'Ampersand & forward slash / comma ,',
      "name with apostrophe ' && full stop... exclamation mark !",
      'ěą śpórt cīnī gęń'
    ].each do |valid_name|
      let(:company_name) { valid_name }

      it { is_expected.to be_valid }
    end
  end

  context 'when company name has invalid format' do
    [
      '(Parentheses not allowed)',
      'also some other chars *',
      '#stayathome',
      "(>'')> <(''<)"
    ].each do |invalid_name|
      let(:company_name) { invalid_name }

      it { is_expected.not_to be_valid }

      it 'has proper error message' do
        subject.valid?
        expect(subject.errors.messages[:company_name]).to include(
          I18n.t('company_name_form.company_name_invalid_format')
        )
      end
    end
  end
end
