# frozen_string_literal: true

require 'rails_helper'

describe SessionManipulation::SetNewUserPermissions do
  subject do
    described_class.call(session: session, params: { permissions: permissions })
  end

  let(:session) { { new_user: {} } }
  let(:manage_users) { 'MANAGE_USERS' }
  let(:manage_vehicles) { 'MANAGE_VEHICLES' }
  let(:permissions) { [manage_vehicles, manage_users] }

  it 'sets new_user MANAGE_VEHICLES permission in session' do
    subject
    expect(session[:new_user]['permissions']).to include(manage_vehicles)
  end

  it 'sets new_user MANAGE_USERS permission in session' do
    subject
    expect(session[:new_user]['permissions']).to include(manage_users)
  end
end
