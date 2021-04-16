# frozen_string_literal: true

shared_examples 'an invalid country input' do
  it 'has a proper error message' do
    expect(subject.error_object[:country][:message]).to eq('Choose UK or Non-UK')
  end

  it 'has a proper link value' do
    expect(subject.error_object[:country][:link]).to eq('#country-error')
  end
end
