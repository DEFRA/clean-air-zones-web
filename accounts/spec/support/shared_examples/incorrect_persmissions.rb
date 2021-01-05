# frozen_string_literal: true

shared_examples 'incorrect permissions' do
  context 'when no permissions' do
    before do
      sign_in create_user(permissions: [])
      subject
    end

    it 'redirects to not found page' do
      expect(response).to redirect_to(not_found_path)
    end
  end
end
