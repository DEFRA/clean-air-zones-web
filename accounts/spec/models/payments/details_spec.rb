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
  let(:zone_id) { mocked_uuid }
  let(:reference) { SecureRandom.uuid }
  let(:id) { SecureRandom.uuid }
  let(:email) { 'test@example.com' }

  before { mock_clean_air_zones }

  it { expect(subject.clean_air_zone).to be_an_instance_of(CleanAirZone) }
  it { expect(subject.user_email).to eq(email) }
  it { expect(subject.reference).to eq(reference) }
  it { expect(subject.external_id).to eq(id) }
  it { expect(subject.total_charge).to eq(total_charge) }
  it { expect(subject.entries_paid).to eq(entries_paid) }
end
