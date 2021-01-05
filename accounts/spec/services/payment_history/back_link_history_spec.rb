# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PaymentHistory::BackLinkHistory do
  subject do
    described_class.call(
      session: session,
      session_key: session_key,
      back_button: back_button,
      page: page,
      default_url: default_url,
      url: url
    )
  end

  let(:session) { {} }
  let(:session_key) { :company_back_link_history }
  let(:back_button) { false }
  let(:page) { 1 }
  let(:default_url) { 'http://www.example.com/dashboard' }
  let(:url) { 'http://www.example.com/company_payment_history' }

  describe '#call' do
    context 'when session is empty and back button is false' do
      it 'returns search url' do
        expect(subject).to include('/dashboard')
      end
    end

    context 'when session is empty and back button is true' do
      let(:back_button) { true }

      it 'returns search url' do
        expect(subject).to include('/dashboard')
      end

      it 'adding first step to the session' do
        subject
        expect(session[:company_back_link_history]).to eq({ '1' => 1 })
      end
    end

    context 'when session is not empty and back button is false' do
      let(:session) { { company_back_link_history: { '1' => 1 } } }
      let(:page) { 4 }

      it 'returns correct page' do
        expect(subject).to include('page=1')
      end

      it 'adding steps to the session' do
        subject
        expect(session[:company_back_link_history]).to eq({ '1' => 1, '2' => 4 })
      end
    end

    context 'when session is not empty, back button is false and last page the same with new one' do
      let(:session) { { company_back_link_history: { '1' => 1 } } }
      let(:page) { 1 }

      it 'returns correct page' do
        expect(subject).to include('dashboard')
      end

      it 'not adding steps to the session' do
        subject
        expect(session[:company_back_link_history]).to eq({ '1' => 1 })
      end
    end

    context 'when session is not empty, back button is true and last page the same with new one' do
      let(:session) { { company_back_link_history: { '1' => 1, '2' => 4 } } }
      let(:page) { 4 }
      let(:back_button) { true }

      it 'returns correct page' do
        expect(subject).to include('page=1?back=true')
      end

      it 'not adding steps to the session' do
        subject
        expect(session[:company_back_link_history]).to eq({ '1' => 1, '2' => 4 })
      end
    end

    context 'when session is not empty and back button is true' do
      let(:session) { { company_back_link_history: { '1' => 1, '2' => 4 } } }
      let(:back_button) { true }

      it 'returns correct page' do
        expect(subject).to include('dashboard')
      end

      it 'removes keys from next steps' do
        subject
        expect(session[:company_back_link_history]).to eq({ '1' => 1 })
      end
    end

    context 'when in session already 10 steps and back button is false' do
      let(:session) do
        {
          company_back_link_history:
          {
            '1' => 1,
            '2' => 2,
            '3' => 3,
            '4' => 4,
            '5' => 5,
            '6' => 6,
            '7' => 7,
            '8' => 8,
            '9' => 9,
            '10' => 10
          }
        }
      end

      it 'returns correct page' do
        expect(subject).to include('page=10')
      end

      before { subject }

      it 'removes first step and adding next one' do
        expect(session[:company_back_link_history]).to include({ '11' => 1 })
        expect(session[:company_back_link_history]).to_not include({ '1' => 1 })
      end
    end

    context 'when in session already 10 steps and back button is true' do
      let(:session) do
        {
          company_back_link_history:
          {
            '1' => 1,
            '2' => 2,
            '3' => 3,
            '4' => 4,
            '5' => 5,
            '6' => 6,
            '7' => 7,
            '8' => 8,
            '9' => 9,
            '10' => 10
          }
        }
      end
      let(:back_button) { true }

      it 'returns correct page' do
        expect(subject).to include('page=9')
      end

      before { subject }

      it 'not adding the next step' do
        expect(session[:company_back_link_history]).to include({ '1' => 1 })
        expect(session[:company_back_link_history]).to include({ '10' => 10 })
        expect(session[:company_back_link_history]).to_not include({ '11' => 1 })
      end
    end
  end
end
