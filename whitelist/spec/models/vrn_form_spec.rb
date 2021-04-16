# frozen_string_literal: true

require 'rails_helper'

describe VrnForm, type: :model do
  subject { described_class.new(vrn) }

  let(:vrn) { 'CU57ABC' }

  context 'with proper VRN' do
    it { is_expected.to be_valid }
  end

  context 'VRN validation' do
    before { subject.valid? }

    context 'when VRN is empty' do
      let(:vrn) { '' }

      it { is_expected.not_to be_valid }

      it_behaves_like 'an invalid attribute input', :vrn, I18n.t('vrn_form.errors.vrn_missing')
    end

    context 'when VRN is too long' do
      let(:vrn) { '123456789012345' }

      it { is_expected.not_to be_valid }

      it_behaves_like 'an invalid attribute input', :vrn, I18n.t('vrn_form.errors.vrn_too_long')
    end

    context 'when VRN is too short' do
      let(:vrn) { 'A' }

      it { is_expected.not_to be_valid }

      it_behaves_like 'an invalid attribute input', :vrn, I18n.t('vrn_form.errors.vrn_too_short')
    end

    context 'when VRN has special signs' do
      let(:vrn) { 'ABCDE$%' }

      it_behaves_like 'an invalid attribute input',
                      :vrn,
                      I18n.t('vrn_form.errors.vrn_invalid_format')
    end
  end
end
