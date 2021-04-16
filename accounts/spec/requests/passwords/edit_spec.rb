# frozen_string_literal: true

require 'rails_helper'

describe 'PasswordsController - GET #edit', type: :request do
  subject { get edit_passwords_path }

  context 'when signed in' do
    before { sign_in create_user }

    it 'renders the view' do
      expect(subject).to render_template(:edit)
    end
  end

  it_behaves_like 'a login required'
end
