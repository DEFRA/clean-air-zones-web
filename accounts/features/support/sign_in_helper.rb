# frozen_string_literal: true

# helper methods for logging in users
module SignInHelper
  def login_user(options)
    user = new_user(options)
    allow_any_instance_of(User).to receive(:authentication).and_return(user)
    fill_sign_in_form
  end

  def login_owner
    owner = new_user(owner: true)
    allow_any_instance_of(User).to receive(:authentication).and_return(owner)
    fill_sign_in_form
  end

  def fill_sign_in_form
    allow_any_instance_of(ActionDispatch::Request).to receive(:remote_ip).and_return(remote_ip)
    visit new_user_session_path
    fill_in('user_email', with: 'test@example.com')
    fill_in('user_password', with: 'password')
    click_button 'Continue'
  end

  private

  def new_user(options = {})
    User.new(
      email: options[:email] || 'test@example.com',
      owner: options[:owner] || false,
      login_ip: options[:remote_ip] || remote_ip,
      **account_data(options)
    )
  end

  def account_data(options)
    {
      user_id: options[:user_id] || SecureRandom.uuid,
      account_id: options[:account_id] || SecureRandom.uuid,
      account_name: options[:account_name] || 'Royal Mail',
      permissions: options[:permissions] || account_permissions,
      days_to_password_expiry: options[:days_to_password_expiry] || 90,
      beta_tester: options[:beta_tester] || false
    }
  end

  def account_permissions
    %w[MANAGE_VEHICLES MANAGE_MANDATES MAKE_PAYMENTS MANAGE_USERS]
  end

  def remote_ip
    '1.2.3.4'
  end
end

World(SignInHelper)
