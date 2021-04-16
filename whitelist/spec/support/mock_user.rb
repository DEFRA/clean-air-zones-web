# frozen_string_literal: true

module MockUser
  # returns mocked user instance
  def new_user(options = {})
    User.new(
      email: options[:email] || 'test@example.com',
      username: options[:email] || 'test@example.com',
      **account_data(options),
      login_ip: options[:login_ip] || @remote_ip
    )
  end

  private

  def account_data(options)
    {
      sub: options[:sub] || 'fb39da4f-a2dc-46fd-921c-74a7abde5745',
      preferred_username: options[:preferred_username] || 'fb39da4f-a2dc-46fd-921c-74a7abde5745',
      aws_status: options[:aws_status] || nil,
      aws_session: options[:aws_session] || nil,
      hashed_password: options[:aws_session] || nil
    }
  end
end
