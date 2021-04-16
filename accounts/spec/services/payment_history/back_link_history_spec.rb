# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PaymentHistory::BackLinkHistory do
  subject do
    described_class.call(
      session: session,
      back_button: back_button,
      page: page,
      default_url: default_url,
      url: url
    )
  end

  let(:session) { {} }
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
        expect(session[:back_link_history]).to eq({ '1' => 1 })
      end
    end

    context 'when session is not empty and back button is false' do
      let(:session) { { back_link_history: { '1' => 1 } } }
      let(:page) { 4 }

      it 'returns correct page' do
        expect(subject).to include('page=1')
      end

      it 'adding steps to the session' do
        subject
        expect(session[:back_link_history]).to eq({ '1' => 1, '2' => 4 })
      end
    end

    context 'when session is not empty, back button is false and last page the same with new one' do
      let(:session) { { back_link_history: { '1' => 1 } } }
      let(:page) { 1 }

      it 'returns correct page' do
        expect(subject).to include('dashboard')
      end

      it 'not adding steps to the session' do
        subject
        expect(session[:back_link_history]).to eq({ '1' => 1 })
      end
    end

    context 'when session is not empty, back button is true and last page the same with new one' do
      let(:session) { { back_link_history: { '1' => 1, '2' => 4 } } }
      let(:page) { 4 }
      let(:back_button) { true }

      it 'returns correct page' do
        expect(subject).to include('page=1?back=true')
      end

      it 'not adding steps to the session' do
        subject
        expect(session[:back_link_history]).to eq({ '1' => 1, '2' => 4 })
      end
    end

    context 'when session is not empty and back button is true' do
      let(:session) { { back_link_history: { '1' => 1, '2' => 4 } } }
      let(:back_button) { true }

      it 'returns correct page' do
        expect(subject).to include('dashboard')
      end

      it 'removes keys from next steps' do
        subject
        expect(session[:back_link_history]).to eq({ '1' => 1 })
      end
    end

    context 'when in session already 10 steps and back button is false' do
      let(:session) do
        {
          back_link_history:
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

      before { subject }

      it 'returns correct page' do
        expect(subject).to include('page=10')
      end

      it 'adding the next step' do
        expect(session[:back_link_history]).to include({ '11' => 1 })
      end

      it 'removes first step' do
        expect(session[:back_link_history]).not_to include({ '1' => 1 })
      end
    end

    context 'when in session already 10 steps and back button is true' do
      let(:session) do
        {
          back_link_history:
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

      before { subject }

      it 'returns correct page' do
        expect(subject).to include('page=9')
      end

      it 'return a proper value for first step' do
        expect(session[:back_link_history]).to include({ '1' => 1 })
      end

      it 'return a proper value for tenth step' do
        expect(session[:back_link_history]).to include({ '10' => 10 })
      end

      it 'not adding the eleventh step' do
        expect(session[:back_link_history]).not_to include({ '11' => 1 })
      end
    end
  end
end
