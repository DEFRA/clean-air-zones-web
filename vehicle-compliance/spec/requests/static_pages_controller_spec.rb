# frozen_string_literal: true

require 'rails_helper'

describe StaticPagesController do
  describe 'GET #accessibility_statement' do
    subject { get accessibility_statement_path }

    it 'returns a 200 OK status' do
      subject
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #cookies' do
    subject { get cookies_path }

    it 'returns a 200 OK status' do
      subject
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #privacy_notice' do
    subject { get privacy_notice_path }

    it 'returns a 200 OK status' do
      subject
      expect(response).to have_http_status(:ok)
    end
  end
end
