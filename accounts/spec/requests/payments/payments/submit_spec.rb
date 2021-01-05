# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentsController - POST #submit' do
  subject { post matrix_payments_path, params: params }

  let(:params) do
    {
      commit: commit,
      payment: {
        vehicles: { @vrn => dates },
        vrn_search: search,
        next_vrn: next_vrn,
        previous_vrn: prev_vrn,
        vrn_list: @vrn
      }
    }
  end

  let(:next_vrn) { 'CU1234' }
  let(:prev_vrn) { 'CAS123' }
  let(:commit) { 'Continue' }
  let(:dates) { ['2020-03-08'] }
  let(:search) { 'test' }

  context 'correct permissions' do
    before { sign_in create_user }

    it 'redirects to the :index' do
      expect(subject).to redirect_to(payments_path)
    end

    context 'with caz_id and vehicle details in the session' do
      before do
        add_to_session(new_payment: { caz_id: @uuid, details: { @vrn => { dates: [] } } })
        subject
      end

      context 'when commit is continue' do
        it 'redirects to the :review' do
          expect(response).to redirect_to(review_payments_path)
        end

        it 'saves new payment data' do
          expect(session[:new_payment]['details'][@vrn][:dates]).to eq(dates)
        end
      end

      context 'when commit is search' do
        let(:commit) { 'Search' }

        it_behaves_like 'a non continue matrix commit'

        it 'saves only search' do
          expect(session[:payment_query].keys).to contain_exactly(:search)
        end
      end

      context 'when commit is next' do
        let(:commit) { 'Next' }

        it_behaves_like 'a non continue matrix commit'

        it 'saves next vrn' do
          expect(session[:payment_query][:vrn]).to eq(next_vrn)
        end

        it 'saves direction' do
          expect(session[:payment_query][:direction]).to eq('next')
        end
      end

      context 'when commit is previous' do
        let(:commit) { 'Previous' }

        it_behaves_like 'a non continue matrix commit'

        it 'saves previous vrn' do
          expect(session[:payment_query][:vrn]).to eq(prev_vrn)
        end

        it 'saves direction' do
          expect(session[:payment_query][:direction]).to eq('previous')
        end
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
