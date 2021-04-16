# frozen_string_literal: true

require 'rails_helper'

describe CheckPermissionsHelper do
  describe '.checked_permission?' do
    subject { helper.checked_permission?('MANAGE_VEHICLES') }

    let(:permissions) { %w[MANAGE_VEHICLES MANAGE_USERS] }

    before do
      session[:new_user] = { permissions: permissions }.stringify_keys
      subject
    end

    context 'when new_user permissions is correct' do
      it { is_expected.to be_truthy }
    end

    context 'when new_user permissions is incorrect' do
      let(:permissions) { 'MANAGE_USERS' }

      it { is_expected.to be_falsey }
    end

    context 'when new_user permissions is nil' do
      let(:permissions) { nil }

      it { is_expected.to be_nil }
    end
  end
end
