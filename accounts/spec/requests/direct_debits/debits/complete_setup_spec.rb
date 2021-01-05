# frozen_string_literal: true

require 'rails_helper'

describe 'DirectDebits::DebitsController - GET #complete_setup' do
  subject { get complete_setup_debits_path, params: { redirect_flow_id: 'RE0002VT8ZDTEM1PE4T8W730KBDFH54X' } }

  context 'correct permissions' do
    before do
      mock_direct_debit_enabled
      sign_in manage_mandates_user
    end

    context 'when mandate_caz_id in session' do
      before { add_to_session(mandate_caz_id: @uuid) }

      context 'and api returns 200 status' do
        before { allow(DebitsApi).to receive(:complete_mandate_creation).and_return({}) }

        it 'redirects to the debits page' do
          expect(subject).to redirect_to(debits_path)
        end
      end

      context 'and api returns 400 status' do
        before do
          allow(DebitsApi).to receive(:complete_mandate_creation).and_raise(
            BaseApi::Error400Exception.new(400, '', {})
          )
        end

        it 'renders the service unavailable page' do
          expect(subject).to render_template(:service_unavailable)
        end
      end

      context 'and api returns 400 status because mandate was already created ' do
        before do
          allow(DebitsApi).to receive(:complete_mandate_creation).and_raise(
            BaseApi::Error400Exception.new(
              400,
              '',
              { 'message' => 'Your integration has already completed this redirect flow' }
            )
          )
        end

        it 'redirects to the debits page' do
          expect(subject).to redirect_to(debits_path)
        end
      end
    end

    context 'without mandate_caz_id in session' do
      before do
        allow(DebitsApi).to receive(:complete_mandate_creation).and_raise(
          BaseApi::Error401Exception.new(401, '', {})
        )
      end

      it 'redirects to the debits page' do
        expect(subject).to redirect_to(debits_path)
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
