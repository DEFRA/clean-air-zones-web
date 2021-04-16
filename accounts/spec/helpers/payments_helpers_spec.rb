# frozen_string_literal: true

require 'rails_helper'

describe PaymentsHelper do
  let(:vrn) { 'ABC123' }
  let(:date) { '2019-11-03' }

  describe '.checked?' do
    subject { helper.checked?(vrn, date) }

    context 'when there is no date in the session' do
      it { is_expected.to be_falsey }
    end

    context 'when date is in the session' do
      before { session[:new_payment] = { details: { vrn => { dates: [date, '2019-11-05'] } } } }

      it { is_expected.to be_truthy }
    end

    context 'when date is not in the session' do
      before { session[:new_payment] = { details: { vrn => { dates: %w[2019-11-04 2019-11-05] } } } }

      it { is_expected.to be_falsey }
    end
  end

  describe '.paid?' do
    subject { helper.paid?(vehicle, date) }

    let(:vehicle) { instance_double(Payments::Vehicle, paid_dates: dates) }

    context 'when there is no dates in the paid_dates' do
      let(:dates) { [] }

      it { is_expected.to be_falsey }
    end

    context 'when the given date is in the paid_dates' do
      let(:dates) { [date, '2019-11-05'] }

      it { is_expected.to be_truthy }
    end
  end

  describe '.parse_date' do
    it 'returns a proper value' do
      expect(helper.parse_date(date)).to eq('Sunday 03 November 2019')
    end
  end

  describe '.single_vrn_parsed_charge' do
    let(:dates) { %w[2019-11-04 2019-11-05] }

    it 'returns a proper value' do
      expect(helper.single_vrn_parsed_charge(dates, 5)).to eq('£10.00')
    end
  end

  describe '.exemption_url_for' do
    let(:caz) do
      instance_double CleanAirZone,
                      name: 'Bath',
                      exemption_url: 'www.example.com'
    end

    it 'returns a proper value' do
      expect(helper.exemption_url_for(caz)).to include('Bath (opens in a new window)')
    end
  end
end
