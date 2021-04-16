# frozen_string_literal: true

require 'rails_helper'

describe ComplianceDetailsBase, type: :model do
  subject { ComplianceDetails.new(details, false) }

  let(:details) do
    {
      'name' => name,
      'operatorName' => 'Birmingham City Council',
      'charge' => 5.1,
      'informationUrls' => {
        'boundary' => 'www.example.com',
        'mainInfo' => 'www.example.com',
        'publicTransportOptions' => 'www.example.com',
        'exemptionOrDiscount' => 'www.example.com',
        'becomeCompliant' => 'www.example.com'
      }
    }
  end

  let(:name) { 'Birmingham' }

  describe '.charging_starts' do
    context 'when caz name is Birmingham' do
      context 'with caz charging is not live' do
        it 'returns a proper value' do
          expect(subject.charging_starts).to eq('1 June 2021')
        end
      end

      context 'with caz charging is live' do
        it 'returns a proper value' do
          travel_to Time.zone.local(2021, 0o7, 0o1, 0o0, 0o0, 0o1) do
            expect(subject.charging_starts).to eq('Now')
          end
        end
      end
    end

    context 'when caz name is Bath' do
      let(:name) { 'Bath' }

      context 'with caz charging is live' do
        it 'returns a proper value' do
          travel_to Time.zone.local(2021, 0o3, 15, 0o0, 0o0, 0o1) do
            expect(subject.charging_starts).to eq('Now')
          end
        end
      end
    end

    context 'when another caz name' do
      let(:name) { 'Futurecleanairzone' }

      it 'returns a proper value' do
        expect(subject.charging_starts).to eq('Early 2021')
      end
    end
  end
end
