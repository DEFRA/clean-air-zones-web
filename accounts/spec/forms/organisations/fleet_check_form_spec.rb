# frozen_string_literal: true

require 'rails_helper'

describe Organisations::FleetCheckForm, type: :model do
  subject { described_class.new(confirm_fleet_check: confirm_fleet_check) }

  let(:confirm_fleet_check) { 'less_than_two' }

  it { is_expected.to be_valid }

  context 'when confirm_fleet_check is empty' do
    let(:confirm_fleet_check) { '' }

    it { is_expected.not_to be_valid }

    it 'has a proper error message' do
      subject.valid?
      expect(subject.errors.messages[:confirm_fleet_check]).to(
        include(I18n.t('fleet_check_form.errors.confirm_fleet_check'))
      )
    end
  end
end
