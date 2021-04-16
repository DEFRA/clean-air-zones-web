# frozen_string_literal: true

require 'rails_helper'

describe NewVrnForm, type: :model do
  subject { described_class.new(params) }

  let(:params) { { vrn: vrn, category: category, manufacturer: manufacturer, reason: reason } }
  let(:vrn) { 'CU57ABC' }
  let(:category) { 'Early Adopter' }
  let(:manufacturer) { 'ZAZ' }
  let(:reason) { 'Testing' }

  context 'passes validation' do
    context 'with proper params' do
      it { is_expected.to be_valid }
    end

    context 'with special characters in manufacturer' do
      let(:manufacturer) { 'Mercedes-benz.}{()().{}[]",-{}\\/' }
      it { is_expected.to be_valid }
    end

    context 'real manufacturer is valid mercedes' do
      let(:manufacturer) { 'Mercedes-Benz' }
      it { is_expected.to be_valid }
    end

    context 'real manufacturer is valid Bristol' do
      let(:manufacturer) { 'Bristol (BLMC)' }
      it { is_expected.to be_valid }
    end

    context 'real manufacturer is valid BSA' do
      let(:manufacturer) { 'BSA D14/4' }
      it { is_expected.to be_valid }
    end

    context 'real manufacturer is valid Thor Ace' do
      let(:manufacturer) { 'Thor Ace 30.1' }
      it { is_expected.to be_valid }
    end
  end

  context 'VRN validation' do
    before { subject.valid? }

    context 'when VRN is empty' do
      let(:vrn) { '' }

      it { is_expected.not_to be_valid }

      it_behaves_like 'an invalid attribute input', :vrn, I18n.t('vrn_form.errors.vrn_missing')
    end

    context 'when VRN is too long' do
      let(:vrn) { 'ABCDE' * 4 }

      it { is_expected.not_to be_valid }

      it_behaves_like 'an invalid attribute input', :vrn, I18n.t('vrn_form.errors.vrn_too_long')
    end

    context 'when VRN has special signs' do
      let(:vrn) { 'ABCDE$%' }

      it_behaves_like 'an invalid attribute input',
                      :vrn,
                      I18n.t('vrn_form.errors.vrn_invalid_format')
    end
  end

  context 'category validation' do
    before { subject.valid? }

    context 'when category is empty' do
      let(:category) { '' }

      it { is_expected.not_to be_valid }

      it_behaves_like 'an invalid attribute input',
                      :category,
                      I18n.t('input_form.errors.missing', attribute: 'Category')
    end
  end

  context 'manufacturer validation' do
    before { subject.valid? }

    context 'when category is empty' do
      let(:manufacturer) { '' }

      it { is_expected.to be_valid }
    end

    context 'when manufacturer is too long' do
      let(:manufacturer) { 'Manufacturer' * 5 }

      it { is_expected.not_to be_valid }

      it_behaves_like 'an invalid attribute input',
                      :manufacturer,
                      'Manufacturer is too long (maximum is 50 characters)'
    end

    context 'when manufacturer has special signs' do
      let(:manufacturer) { '-_@:$%' }

      it { is_expected.not_to be_valid }

      it_behaves_like 'an invalid attribute input',
                      :manufacturer,
                      'Manufacturer is in an invalid format'
    end

    context 'not valid special signs ' do
      let(:manufacturer) { 'fdfd$£&@(' }

      it { is_expected.not_to be_valid }

      it_behaves_like 'an invalid attribute input',
                      :manufacturer,
                      'Manufacturer is in an invalid format'
    end

    context 'not valid special signs 2' do
      let(:manufacturer) { 'sfdgsdg&*(' }

      it { is_expected.not_to be_valid }

      it_behaves_like 'an invalid attribute input',
                      :manufacturer,
                      'Manufacturer is in an invalid format'
    end

    context 'not valid special signs 3' do
      let(:manufacturer) { 'aasdf&*!(' }

      it { is_expected.not_to be_valid }

      it_behaves_like 'an invalid attribute input',
                      :manufacturer,
                      'Manufacturer is in an invalid format'
    end
  end

  context 'reason validation' do
    before { subject.valid? }

    context 'when reason is empty' do
      let(:reason) { '' }

      it { is_expected.not_to be_valid }

      it_behaves_like 'an invalid attribute input',
                      :reason,
                      I18n.t('input_form.errors.missing', attribute: 'Reason')
    end

    context 'when VRN is too long' do
      let(:reason) { 'ABCDE' * 11 }

      it { is_expected.not_to be_valid }

      it_behaves_like 'an invalid attribute input',
                      :reason, 'Reason is too long (maximum is 50 characters)'
    end

    context 'when reason has special signs' do
      let(:reason) { '-_@:$%' }

      it { is_expected.not_to be_valid }

      it_behaves_like 'an invalid attribute input',
                      :reason,
                      'Reason is in an invalid format'
    end

    context 'when reason has special signs' do
      let(:reason) { 'mercedes-benz' }

      it { is_expected.not_to be_valid }

      it_behaves_like 'an invalid attribute input',
                      :reason,
                      'Reason is in an invalid format'
    end
  end
end
