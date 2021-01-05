# frozen_string_literal: true

RSpec.shared_examples 'a non continue matrix commit' do
  it 'redirects to :matrix' do
    expect(subject).to redirect_to(matrix_payments_path)
  end

  it 'saves new payment data' do
    subject
    expect(session[:new_payment]['details'][@vrn][:dates]).to eq(dates)
  end
end
