# frozen_string_literal: true

RSpec.shared_examples 'company name is missing' do
  it 'redirects to :root' do
    expect(subject).to redirect_to(root_path)
  end
end
