# frozen_string_literal: true

RSpec.shared_examples 'an invalid login param' do
  it 'redirects the login view' do
    expect(subject).to render_template(:new)
  end

  it 'does not call AccountApi.sign_in' do
    expect(AccountsApi::Auth).not_to receive(:sign_in)
    subject
  end
end
