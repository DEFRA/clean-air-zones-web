# frozen_string_literal: true

require 'rails_helper'

describe SessionManipulation::AddPaymentDetails do
  subject { described_class.call(params: params, session: session) }

  let(:id) { @uuid }
  let(:params) { { payment: { vehicles: vehicles_data, vrn_list: list } } }
  let(:vehicles_data) { { @vrn => dates } }
  let(:session) { { new_payment: { caz_id: id, details: details } } }
  let(:dates) { %w[2019-11-04 2019-11-05] }
  let(:details) { { @vrn => { dates: [] } } }
  let(:list) { @vrn }

  before { subject }

  it 'adds details for @vrn' do
    expect(session[:new_payment][:details][@vrn][:dates]).to eq(dates)
  end

  it 'keeps LA ID' do
    expect(session[:new_payment][:caz_id]).to eq(id)
  end

  context 'with other dates for @vrn' do
    let(:details) { { @vrn => { dates: ['2019-11-06'] } } }

    it 'overrides details for @vrn' do
      expect(session[:new_payment][:details][@vrn][:dates]).to eq(dates)
    end

    context 'when @vrn is not on the vrn_list' do
      let(:list) { %w[CU1234 ABC123].join(',') }

      it 'does not override details for @vrn' do
        expect(session[:new_payment][:details]).to eq(details)
      end
    end

    context 'when @vrn is not present in the params' do
      let(:vehicles_data) { {} }

      it 'sets dates to empty array for @vrn' do
        expect(session[:new_payment][:details][@vrn][:dates]).to eq([])
      end
    end
  end
end
