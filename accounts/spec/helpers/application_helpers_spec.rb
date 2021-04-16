# frozen_string_literal: true

require 'rails_helper'

describe ApplicationHelper do
  describe '.formatted_timestamp' do
    let(:date) { '2020-04-30T08:08:31' }

    it 'returns a proper date format' do
      expect(helper.formatted_timestamp(date)).to eq('Thursday 30 April 2020')
    end
  end

  describe '.formatted_date' do
    let(:date) { Date.parse('2020-09-04') }

    it 'returns a proper date format' do
      expect(helper.formatted_date(date)).to eq('Friday 04 September 2020')
    end
  end

  describe '.single_vehicle_payment_link' do
    it 'returns a proper date format' do
      expect(helper.single_vehicle_payment_link).to include('vehicles/enter_details')
    end
  end
end
