# frozen_string_literal: true

require 'rails_helper'

describe 'DirectDebits::DebitsController - POST #initiate' do
  subject { post initiate_debits_path }

  context 'correct permissions' do
    before do
      add_to_session(new_payment: { caz_id: @uuid, payment_id: @uuid, details: details })
      sign_in make_payments_user
    end

    let(:details) do
      {
        'CU12345' =>
        {
          'vrn' => 'CU12345',
          'tariff' => 'BCC01-HEAVY GOODS VEHICLE',
          'charge' => 50.0,
          'dates' => ['2020-09-25']
        }
      }
    end

    context 'when api returns 201 status' do
      before do
        allow(Payments::MakeDebitPayment).to receive(:call)
          .and_return(read_response('/debits/create_payment.json'))
        subject
      end

      it 'redirects to the success payment page' do
        expect(response).to redirect_to(success_debits_path)
      end
    end

    context 'when api returns 400 status' do
      before do
        allow(DebitsApi).to receive(:create_payment)
          .and_raise(BaseApi::Error400Exception.new(400, '', ''))
        subject
      end

      it 'redirects to the failure dd payment page' do
        expect(response).to redirect_to(failure_debits_path)
      end
    end

    context 'when api returns 422 status' do
      before do
        allow(DebitsApi).to receive(:create_payment)
          .and_raise(BaseApi::Error422Exception.new(422, '', ''))
        subject
      end

      it 'redirects to the failure dd payment page' do
        expect(response).to redirect_to(failure_debits_path)
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
