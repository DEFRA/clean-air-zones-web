# frozen_string_literal: true

##
# Controller class for the password change
#
class PasswordsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :check_password_age
  before_action :authenticate_user!, only: %i[edit update]
  before_action :validate_token, only: :create

  ##
  # Renders the reset password page.
  #
  # ==== Path
  #
  #    :GET /passwords/reset
  #
  def reset
    @back_button_url = if request.referer&.include?(set_up_confirmation_users_path)
                         set_up_confirmation_users_path
                       elsif session[:reset_password_back_button_url]
                         session[:reset_password_back_button_url]
                       else
                         new_user_session_path
                       end
  end

  ##
  # Validates submitted email_address.
  # If successful, redirects to the {new_user_session}[rdoc-ref:Devise::SessionController.new]
  # If no, renders {reset} [rdoc-ref:PasswordsController.new]
  #
  # ==== Path
  #
  #    :POST /passwords/reset
  #
  # ==== Params
  # * +passwords+ - hash
  #    * +email_address+ - submitted email address
  #
  def validate
    form = ResetPasswordForm.new(email_address_params)
    if form.valid?
      AccountsApi::Auth.initiate_password_reset(email: form.email_address, reset_url: passwords_url)
      redirect_to email_sent_passwords_path
    else
      @errors = form.errors.messages
      render :reset
    end
  end

  ##
  # Renders the static page after sending an reset password email.
  #
  # ==== Path
  #
  #    :GET /passwords/email_sent
  #
  def email_sent
    # renders static page
  end

  ##
  # Validates the token by calling AccountsApi::Auth.validate_password_reset and renders new password form.
  #
  # ==== Path
  #
  #    :GET /passwords
  #
  # ==== Params
  # * +token+ - uuid, required in the query
  #
  def index
    form = TokenForm.new(token: params[:token])
    return redirect_to invalid_passwords_path unless form.valid?

    @token = form.token
    session[:reset_password_token] = @token
  end

  ##
  # Sets a new password by calling AccountsApi::Auth.set_password
  #
  # ==== Path
  #    :POST /passwords
  #
  # ==== Params
  # * +token+ - token from the email, passes as a hidden param in the form
  # * +reset_password_token+ - token assigned in the render action, present in the session
  # * +passwords+ - hash
  #    * +password+ - string, submitted password
  #    * +password_confirmation+ - string, submitted confirmation
  #
  def create
    form = NewPasswordForm.new(
      password: params.dig(:passwords, :password),
      password_confirmation: params.dig(:passwords, :password_confirmation)
    )
    return rerender_index(form.errors.messages) unless form.valid?

    new_password_call(form.password)
  end

  ##
  # Renders the static page when given token in invalid.
  #
  # ==== Path
  #
  #    :GET /passwords/invalid
  #
  def invalid
    # Renders static page
  end

  ##
  # Renders the static page successful password set.
  #
  # ==== Path
  #
  #    :GET /passwords/success
  #
  def success
    # Renders static page
  end

  ##
  # Renders the update password page.
  #
  # ==== Path
  #
  #    :GET /passwords/edit
  #
  def edit
    # Renders static page
  end

  ##
  # Updates user password by calling AccountsApi::Auth.update_password
  #
  # ==== Path
  #
  #    :PATCH /passwords
  #
  def update
    form = UpdatePasswordForm.new(
      user_id: current_user.user_id,
      old_password: params.dig(:passwords, :old_password),
      password: params.dig(:passwords, :password),
      password_confirmation: params.dig(:passwords, :password_confirmation)
    )

    return rerender_edit(form.errors.messages) unless form.valid? && form.submit

    redirect_to_dashboard
  end

  private

  ##
  # Calls AccountsApi::Auth.set_password with given password and the token
  #
  # Escapes 400 and 422 exceptions
  #
  def new_password_call(password)
    AccountsApi::Auth.set_password(token: params[:token], password: password)
    session[:reset_password_token] = nil
    redirect_to success_passwords_path
  rescue BaseApi::Error400Exception
    session[:reset_password_token] = nil
    redirect_to invalid_passwords_path
  rescue BaseApi::Error422Exception => e
    rerender_index({ password: parse_422_error(e.body['errorCode']) })
  end

  # Renders :index with assigned errors and token
  def rerender_index(errors)
    @token = params[:token]
    @errors = errors
    render :index
  end

  # Renders :edit with assigned errors
  def rerender_edit(errors)
    @errors = errors
    render :edit
  end

  # Returns the list of permitted params
  def email_address_params
    params[:passwords].try(:[], :email_address)&.strip!

    params.require(:passwords).permit(:email_address)
  end

  # Validates equality of submitted token and the one stored in the session
  def validate_token
    return if params[:token].present? && params[:token] == session[:reset_password_token]

    redirect_to invalid_passwords_path
  end

  # Sets session flag and redirects to the dashboard after successful password update
  def redirect_to_dashboard
    session[:password_updated] = true
    redirect_to dashboard_path
  end

  # Returns correct error message for 422 error
  def parse_422_error(code)
    case code
    when 'passwordNotValid'
      [I18n.t('input_form.errors.password_complexity')]
    when 'newPasswordReuse'
      [I18n.t('update_password_form.errors.password_reused')]
    else
      'Something went wrong'
    end
  end
end
