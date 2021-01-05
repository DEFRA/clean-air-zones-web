# frozen_string_literal: true

shared_examples 'payment result page' do
  context ':payment_details variable' do
    it 'has correct total_charge value' do
      expect(assigns(:payment_details).total_charge).to eq(150)
    end

    it 'has correct payment reference value' do
      expect(assigns(:payment_details).reference).to eq(1234)
    end

    it 'has correct amount of vehicles paid for' do
      expect(assigns(:payment_details).entries_paid).to eq(3)
    end
  end
end
