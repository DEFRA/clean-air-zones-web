# frozen_string_literal: true

require 'rails_helper'

describe Organisations::ValidateFleetCheck do
  subject { described_class.call(confirm_fleet_check: confirm_fleet_check) }

  let(:confirm_fleet_check) { 'two_or_more' }
  let(:valid) { true }
  let(:errors) { [] }

  context 'when valid params' do
    before do
      allow(Organisations::FleetCheckForm)
        .to receive(:new)
        .and_return(instance_double(Organisations::FleetCheckForm, valid?: valid))
    end

    it 'calls Organisations::FleetCheckForm with proper params' do
      expect(Organisations::FleetCheckForm).to receive(:new).with(confirm_fleet_check: confirm_fleet_check)
      subject
    end
  end

  context 'when invalid params' do
    let(:valid) { false }
    let(:errors) { ActiveModel::Errors.new(['Some error']) }
    let(:fleet_check_form_instance) do
      instance_double(Organisations::FleetCheckForm,
                      valid?: valid,
                      errors: errors,
                      first_error_message: 'test')
    end

    before do
      allow(Organisations::FleetCheckForm)
        .to receive(:new)
        .and_return(fleet_check_form_instance)
    end

    context 'when confirm_fleet_check is invalid' do
      it 'raises `InvalidFleetCheckException` exception with proper errors object' do
        expect { subject }.to raise_error(
          InvalidFleetCheckException
        )
      end
    end
  end

  context 'when confirm_fleet_check is `less_than_two`' do
    let(:confirm_fleet_check) { 'less_than_two' }

    it 'raises `InvalidFleetCheckException` exception' do
      expect { subject }.to raise_error(
        AccountForMultipleVehiclesException
      )
    end
  end
end
