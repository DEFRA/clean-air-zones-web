# frozen_string_literal: true

require 'rails_helper'

describe Payments::Details, type: :model do
  subject do
    described_class.new(
      session_details: session_details,
      entries_paid: entries_paid,
      total_charge: total_charge
    )
  end

  let(:session_details) do
    {
      caz_id: zone_id,
      external_id: id,
      user_email: email,
      payment_reference: reference
    }
  end
  let(:entries_paid) { 5 }
  let(:total_charge) { 150 }
  let(:zone_id) { @uuid }
  let(:reference) { @uuid }
  let(:id) { @uuid }
  let(:email) { 'test@example.com' }
  let(:caz_stub) { instance_double 'CleanAirZone', name: 'Leeds' }

  before { allow(CleanAirZone).to receive(:find).and_return(caz_stub) }

  it { expect(subject.caz_name).to eq('Leeds') }
  it { expect(subject.user_email).to eq(email) }
  it { expect(subject.reference).to eq(reference) }
  it { expect(subject.external_id).to eq(id) }
  it { expect(subject.total_charge).to eq(total_charge) }
  it { expect(subject.entries_paid).to eq(entries_paid) }
end
