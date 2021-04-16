# frozen_string_literal: true

require 'rails_helper'

describe ConfirmDetailsForm, type: :model do
  subject { described_class.new(params) }

  let(:confirm_details) { 'yes' }
  let(:undetermined) { 'false' }
  let(:params) do
    {
      confirm_details: confirm_details,
      undetermined: undetermined
    }
  end

  it { is_expected.to be_valid }

  context 'when fields sets as a parameter' do
    %i[confirm_details undetermined].each do |field|
      it "and sets #{field} value" do
        expect(subject.public_send(field)).to eq(public_send(field))
      end
    end
  end

  describe '.confirmed?' do
    context 'when confirmation equals yes' do
      it 'returns true' do
        expect(subject.confirmed?).to eq(true)
      end
    end

    context 'when confirm_details equals no' do
      let(:confirm_details) { 'no' }

      it 'returns false' do
        expect(subject.confirmed?).to eq(false)
      end
    end
  end

  describe '.undetermined?' do
    context 'when undetermined equals false' do
      it 'returns false' do
        expect(subject.undetermined?).to eq(false)
      end
    end

    context 'when undetermined equals true' do
      let(:undetermined) { 'true' }

      it 'returns true' do
        expect(subject.undetermined?).to eq(true)
      end
    end
  end

  context 'when confirmation is empty' do
    let(:confirm_details) { '' }

    before { subject.valid? }

    it { is_expected.not_to be_valid }

    it 'has a proper error message' do
      expect(subject.errors.messages[:confirm_details]).to include('Select yes if the details are correct')
    end
  end
end
