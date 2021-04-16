# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentsController - POST #submit', type: :request do
  subject { post matrix_payments_path, params: params }

  let(:params) do
    {
      commit: commit,
      payment: {
        vehicles: { vrn => dates },
        vrn_search: search,
        vrn_list: vrn
      }
    }
  end

  let(:commit) { 'Review payment' }
  let(:dates) { ['2020-03-08'] }
  let(:search) { 'test' }
  let(:vrn) { 'ABC123' }

  context 'when correct permissions' do
    before { sign_in create_user }

    it 'redirects to the :index' do
      expect(subject).to redirect_to(payments_path)
    end

    context 'with caz_id and vehicle details in the session' do
      before do
        add_to_session(new_payment: { caz_id: mocked_uuid, details: { vrn => { dates: [] } } })
        subject
      end

      context 'when commit is continue' do
        it 'redirects to the :review' do
          expect(response).to redirect_to(review_payments_path)
        end

        it 'saves new payment data' do
          expect(session[:new_payment]['details'][vrn][:dates]).to eq(dates)
        end
      end

      context 'when commit is search' do
        let(:commit) { 'SEARCH' }

        it 'redirects to :matrix' do
          expect(subject).to redirect_to(matrix_payments_path(page: 1))
        end

        it 'saves new payment data' do
          subject
          expect(session[:new_payment]['details'][vrn][:dates]).to eq(dates)
        end

        it 'saves only search' do
          expect(session[:payment_query].keys).to contain_exactly(:search)
        end
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
