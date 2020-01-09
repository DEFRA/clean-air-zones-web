# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CazForm, type: :model do
  subject(:form) { described_class.new(selected_caz) }

  let(:selected_caz) { %w[London York] }

  it { is_expected.to be_valid }

  it 'has selected caz set as parameter' do
    expect(form.parameter).to eq(selected_caz)
  end

  before :each do
    form.valid?
  end

  context 'when selected caz is empty' do
    let(:selected_caz) { '' }

    it { is_expected.not_to be_valid }

    it 'has a proper error message' do
      expect(form.message).to eq('You must select at least one Clean Air Zone')
    end
  end

  context 'when selected caz is an empty array' do
    let(:selected_caz) { [] }

    it { is_expected.not_to be_valid }

    it 'has a proper error message' do
      expect(form.message).to eq('You must select at least one Clean Air Zone')
    end
  end
end
