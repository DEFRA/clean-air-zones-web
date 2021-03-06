# frozen_string_literal: true

RSpec.shared_examples 'an invalid country input' do
  it 'has a proper error message' do
    expect(form.error_object[:country][:message])
      .to eq('You must choose an answer')
  end

  it 'has a proper link value' do
    expect(form.error_object[:country][:link]).to eq('#country-error')
  end
end
