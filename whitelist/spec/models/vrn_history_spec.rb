# frozen_string_literal: true

require 'rails_helper'

describe VrnHistory, type: :model do
  subject { described_class.new(data) }

  let(:data) do
    {
      'modifyDate' => '2020-03-01',
      'action' => action,
      'category' => category,
      'reasonUpdated' => reason_updated,
      'manufacturer' => manufacturer,
      'uploaderEmail' => uploader_email
    }
  end

  let(:action) { 'created' }
  let(:category) { 'Early Adopter' }
  let(:reason_updated) { 'Testing' }
  let(:manufacturer) { 'ZAZ' }
  let(:uploader_email) { 'user@example.com' }

  describe '.data_upload_date' do
    it 'returns a proper value' do
      expect(subject.data_upload_date).to eq('01/03/2020')
    end
  end

  describe '.action' do
    context 'when value is `created`' do
      it 'returns a proper value' do
        expect(subject.action).to eq('Added')
      end
    end

    context 'when value is not `created`' do
      let(:action) { 'updated' }

      it 'returns a proper value' do
        expect(subject.action).to eq('Updated')
      end
    end
  end

  describe '.category' do
    it 'returns a proper value' do
      expect(subject.category).to eq(category)
    end
  end

  describe '.manufacturer' do
    it 'returns a proper value' do
      expect(subject.manufacturer).to eq('ZAZ')
    end
  end

  describe '.reason_updated' do
    it 'returns a proper value' do
      expect(subject.reason_updated).to eq('Testing')
    end
  end

  describe '.uploader_email' do
    it 'returns a proper value' do
      expect(subject.uploader_email).to eq(uploader_email)
    end
  end
end
