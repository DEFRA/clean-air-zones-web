# frozen_string_literal: true

##
# Class used to validate data submitted on the login page.
#
# ==== Usage
#    form = LoginForm.new('test@example.com', 'password')
#    process_log_in if form.valid?
#
class LoginForm
  include ActiveModel::Validations

  validates :email, presence: { message: I18n.t('login_form.email_missing') }
  validates :password, presence: { message: I18n.t('login_form.password_missing') }
  validates :email, format: {
    with: BaseForm::EMAIL_FORMAT,
    message: I18n.t('login_form.invalid_email')
  }

  ##
  # Initializes the form
  #
  # ==== Attributes
  # * +email+ - email, the email address submitted by the user
  # + +password+ - string, the password submitted by the user
  #
  def initialize(email, password)
    @email = email
    @password = password
  end

  private

  # Attributes reader
  attr_reader :email, :password
end
