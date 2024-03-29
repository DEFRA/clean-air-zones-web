# frozen_string_literal: true

# Sign in methods used in feature tests
module LoginHelpers
  def sign_in_user(groups: user_groups)
    allow(Cognito::AuthUser).to receive(:call).and_return(unchallenged_cognito_user(groups))
    visit new_user_session_path
    basic_sign_in
  end

  def sign_in_challenged_user
    allow(Cognito::AuthUser).to receive(:call).and_return(challenged_cognito_user)
    visit new_user_session_path
    basic_sign_in
  end

  def basic_sign_in
    allow_any_instance_of(ActionDispatch::Request)
      .to receive(:remote_ip)
      .and_return(remote_ip)
    fill_in('user_username', with: 'user@example.com')
    fill_in('user_password', with: '12345678')
    click_button 'Continue'
  end

  def unchallenged_cognito_user(groups = user_groups)
    user = cognito_user
    user.groups = groups
    user.aws_status = 'OK'
    user.aws_session = nil
    user
  end

  def challenged_cognito_user
    user = cognito_user
    user.aws_status = 'FORCE_NEW_PASSWORD'
    user.aws_session = SecureRandom.uuid
    user
  end

  def cognito_user
    User.new(
      username: 'user@example.com',
      groups: user_groups,
      email: 'user@example.com',
      login_ip: remote_ip
    )
  end

  def user_groups
    %w[ntr.search.dev]
  end

  def remote_ip
    '1.2.3.4'
  end
end

World(LoginHelpers)
