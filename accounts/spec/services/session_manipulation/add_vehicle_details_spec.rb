# frozen_string_literal: true

require 'rails_helper'

describe SessionManipulation::AddVehicleDetails do
  subject do
    described_class.call(params: params, session: session)
  end

  let(:params) { VehiclesManagement::ChargeableFleet.new(data).vehicle_list }
  let(:data) { read_response('chargeable_vehicles.json') }
  let(:session) { {} }
  let(:first_vehicle) { params.first }
  let(:last_vehicle) { params.last }

  before { subject }

  it 'saves all vehicles data' do
    expect(session[:new_payment][:details].keys.size).to eq(params.size)
  end

  it 'saves vehicle details' do
    expect(session[:new_payment][:details][first_vehicle.vrn])
      .to eq(first_vehicle.serialize)
  end

  context 'when there is data in the session' do
    let(:session) { { new_payment: { details: { first_vehicle.vrn => old_data } } } }
    let(:old_data) { { vrn: first_vehicle.vrn, dates: ['2020-02-21'] } }

    it 'does not override data for already present vehicles' do
      expect(session[:new_payment][:details][first_vehicle.vrn]).to eq(old_data)
    end

    it 'saves new vehicle details' do
      expect(session[:new_payment][:details][last_vehicle.vrn])
        .to eq(last_vehicle.serialize)
    end
  end
end
