# frozen_string_literal: true

##
# Module used for manage users flow
module UsersManagement
  ##
  # Controller used to create new users
  #
  # rubocop:disable Metrics/ClassLength
  class CreateUsersController < BaseController
    include PaymentFeatures

    before_action :authenticate_user!, except: %i[set_up confirm_set_up set_up_confirmation]
    before_action -> { check_permissions(allow_manage_users?) },
                  except: %i[set_up confirm_set_up set_up_confirmation]
    before_action :check_new_user, only: %i[add_permissions confirm_permissions]
    before_action :check_users_count, only: %i[new create]

    # Handle Bath D-Day notice
    before_action :assign_payment_enabled, only: :add_permissions
    before_action :assign_bath_d_day_date, only: :add_permissions

    ##
    # Renders add a user page
    #
    # ==== Path
    #
    #    GET /users/new
    #
    def new
      @back_button_url = if UsersManagement::AccountUsers.new(
        account_id: current_user.account_id,
        user_id: current_user.user_id
      ).filtered_users.any?
                           users_path
                         else
                           dashboard_path
                         end
    end

    ##
    # Process create user request
    #
    # ==== Path
    #
    #    POST /users
    #
    def create
      SessionManipulation::SetNewUser.call(session: session, params: new_user_params)
      form = UsersManagement::AddUserForm.new(account_id: current_user.account_id, new_user: new_user_data)
      if form.valid?
        redirect_to add_permissions_users_path
      else
        flash.now[:errors] = form.errors.messages
        render :new
      end
    end

    ##
    # Renders add permission for user page
    #
    # ==== Path
    #
    #    GET /users/add-permissions
    #
    def add_permissions
      # Renders add user permissions page
    end

    ##
    # Process confirm user permissions request
    #
    # ==== Path
    #
    #    POST /users/confirm_permissions
    #
    def confirm_permissions
      SessionManipulation::SetNewUserPermissions.call(session: session, params: new_user_permissions_params)
      form = UsersManagement::AddUserPermissionsForm.new(
        current_user: current_user,
        new_user: new_user_data,
        verification_url: set_up_users_url
      )
      handle_permissions_form(form)
    end

    ##
    # Renders confirmation user page
    #
    # ==== Path
    #
    #    GET /users/confirmation
    #
    def confirmation
      flash[:success] = I18n.t('add_user.success', full_user_name: session.dig(:new_user, 'name'))
      @new_user_email = session.dig(:new_user, 'email')
    end

    ##
    # Renders account set up page
    #
    # ==== Path
    #
    #    GET /users/set_up
    #
    def set_up
      return handle_missing_invalid_params unless params[:account] && params[:token]

      account = AccountsApi::Accounts.account(account_id: params[:account])&.symbolize_keys
      @company_name = account[:accountName]&.possessive
    rescue BaseApi::Error404Exception
      handle_missing_invalid_params
    end

    ##
    # Process account set up request
    #
    # ==== Path
    #
    #    POST /users/confirm_set_up
    #
    def confirm_set_up
      parameters = params[:account_set_up].permit(:password, :password_confirmation, :token)
      form = UsersManagement::SetUpAccountForm.new(params: parameters)

      if form.valid? && form.submit
        redirect_to set_up_confirmation_users_path
      else
        handle_invalid_set_up_form(form.errors.messages)
      end
    end

    ##
    # Renders account set up confirmation page
    #
    # ==== Path
    #
    #    GET /users/set_up_confirmation
    #
    def set_up_confirmation
      session[:reset_password_back_button_url] = set_up_confirmation_users_path
    end

    private

    # Handles errors for missing or invalid account set up parameters
    def handle_missing_invalid_params
      flash.now[:errors] = { token: I18n.t('token_form.token_invalid') }
      render :set_up
    end

    # Formats account set up page errors and redirects to :set_up
    def handle_invalid_set_up_form(errors)
      flash[:errors] = {
        token: errors[:token].first,
        password: errors[:password].first,
        password_confirmation: errors[:password_confirmation].first
      }
      Rails.logger.silence do
        redirect_to set_up_users_path(token: params[:token], account: params[:account])
      end
    end

    # Returns new user params
    def new_user_params
      params.require(:new_user).permit(:name, :email)
    end

    # Returns new user permissions params
    def new_user_permissions_params
      return {} unless params[:new_user]

      params.require(:new_user).permit(permissions: [])
    end

    # Returns new user data from session
    def new_user_data
      session[:new_user]
    end

    # Returns new user name from session
    def new_user_name
      session.dig(:new_user, 'name')
    end

    # Returns new user email from session
    def new_user_email
      session.dig(:new_user, 'email')
    end

    # Checks new user data in session, redirect to add new user if data missing
    def check_new_user
      return if new_user_name && new_user_email

      Rails.logger.warn 'New user data is missing in the session. Redirecting to new_user_path'
      redirect_to new_user_path
    end

    # Handle add permissions form for new user
    def handle_permissions_form(form) # rubocop:disable Metrics/AbcSize
      if form.valid?
        form.submit
        redirect_to confirmation_users_path
      elsif form.errors.messages[:email].present?
        flash[:errors] = { email: form.errors.messages[:email] }
        redirect_to new_user_path
      else
        flash.now[:errors] = { permissions: form.errors.messages[:permissions] }
        render :add_permissions
      end
    end

    # Do not allow owner to add more then 10 users
    def check_users_count
      users = UsersManagement::AccountUsers.new(
        account_id: current_user.account_id,
        user_id: current_user.user_id
      ).filtered_users
      redirect_to users_path if users.count > 9
    end
  end
  # rubocop:enable Metrics/ClassLength
end
