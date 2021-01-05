# frozen_string_literal: true

RSpec.shared_examples 'an invalid VrnForm' do |message|
  it { is_expected.not_to be_valid }

  it 'has a proper error message' do
    subject.valid?
    expect(subject.errors[:vrn]).to include(message)
  end
end
