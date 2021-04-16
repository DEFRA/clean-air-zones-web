# frozen_string_literal: true

RSpec.shared_examples 'a vrn required view' do
  it 'redirects to the login page' do
    subject
    expect(response).to redirect_to(new_user_session_path)
  end

  context 'when user is signed in' do
    before { sign_in create_user }

    context 'without VRN in the session' do
      it 'redirects to no VRN path' do
        subject
        expect(response).to redirect_to(no_vrn_path)
      end
    end

    context 'with VRN in the session' do
      before { add_to_session(vrn: mocked_vrn) }

      it 'returns http success' do
        subject
        expect(response).to have_http_status(:success)
      end
    end
  end
end
