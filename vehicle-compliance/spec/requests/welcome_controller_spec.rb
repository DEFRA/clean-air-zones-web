# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WelcomeController, type: :request do
  describe 'GET #index' do
    subject { get welcome_index_path }

    before { subject }

    it 'returns a success response' do
      expect(response).to have_http_status(:success)
    end
  end
end
