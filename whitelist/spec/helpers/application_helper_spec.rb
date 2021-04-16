# frozen_string_literal: true

require 'rails_helper'

describe ApplicationHelper do
  describe '#external_link_to' do
    let(:method) { helper.external_link_to(link_name, link_url, id: link_id) }
    let(:link_name) { 'test link' }
    let(:link_url) { 'www.example.com' }
    let(:link_id) { 'link_id' }

    it 'returns `ActiveSupport::SafeBuffer` class' do
      expect(method.class).to eq(ActiveSupport::SafeBuffer)
    end
  end
end
