# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'sessions' }

  authenticated(:user) { root 'dashboard#index', as: :authenticated_root }
  get :dashboard, to: 'dashboard#index'
  devise_scope(:user) { root to: 'sessions#new' }

  scope controller: 'logout' do
    get 'sign_out', to: 'logout#sign_out_page'
    post 'assign_logout_notice_back_url'
    get 'logout_notice'
    get 'timedout_user'
  end

  resources :passwords, only: %i[index create] do
    collection do
      get :reset
      post :reset, to: 'passwords#validate'
      get :email_sent
      get :invalid
      get :success
      get :edit
      patch :update
    end
  end

  scope module: 'organisations', path: '/' do
    get :create_account, to: 'organisations#create_account'
    post :create_account, to: 'organisations#submit_create_account'

    resources :organisations, only: %i[] do
      collection do
        get :how_many_vehicles
        post :how_many_vehicles, to: 'organisations#submit_how_many_vehicles'
        get :cannot_create
        get :sign_in_details
        post :sign_in_details, to: 'organisations#submit_sign_in_details'
        get :email_sent
        get :resend_email
        get :email_verified
        get :email_verification
        get :verification_failed
        get :verification_expired
      end
    end
  end

  scope module: 'vehicles_management', path: '/' do
    resources :fleets, only: %i[index], path: 'manage_vehicles' do
      collection do
        post :index, to: 'fleets#submit_search'
        get :vrn_not_found, to: 'fleets#vrn_not_found'
        get :choose_method
        post :choose_method, to: 'fleets#submit_choose_method'
        get :first_upload
        get :assign_remove
        get :remove
        post :remove, to: 'fleets#confirm_remove'
        get :export
      end
    end

    resources :vehicles, only: [] do
      collection do
        get :enter_details
        post :enter_details, to: 'vehicles#submit_details'
        get :details
        post :confirm_details
        get :exempt
        get :incorrect_details
        get :not_found
        post :confirm_not_found
        get :local_exemptions
        post :add_to_fleet
        post :confirm_and_add_exempt_vehicle_to_fleet
      end
    end

    resources :uploads, only: %i[index create] do
      collection do
        get :processing
        get :calculating_chargeability
        get :download_template
      end
    end
  end

  scope module: 'payments', path: '/' do
    resources :payments, only: :index do
      collection do
        post :local_authority
        scope '/which_days' do
          get :matrix
          post :matrix, to: 'payments#submit'
          get :vrn_not_found
          post :vrn_not_found, to: 'payments#submit_search'
        end
        get :no_chargeable_vehicles
        get :undetermined_vehicles
        get :clear_search
        get :review
        post :confirm_review
        get :review_details
        get :select_payment_method
        post :select_payment_method, to: 'payments#confirm_payment_method'
        get :initiate, to: 'credit_cards#initiate'
        get :result, to: 'credit_cards#result'
        get :in_progress
        get :success
        get :unsuccessful
        get :post_payment_details
        get :cancel, to: '/direct_debits/debits#cancel'
      end
    end
  end

  scope module: 'direct_debits', path: '/' do
    resources :debits, only: %i[index], path: 'direct_debits' do
      collection do
        get :set_up
        post :set_up, to: 'debits#submit_set_up'
        get :first_mandate
        get :confirm
        post :initiate
        get :success
        get :complete_setup
        get :unsuccessful
      end
    end
  end

  scope module: 'users_management', path: '/' do
    resources :users, controller: 'create_users', only: %i[new create] do
      collection do
        get :index, to: 'users#index'
        get :add_permissions
        post :add_permissions, to: 'create_users#confirm_permissions'
        get :confirmation
        get :set_up
        post :set_up, to: 'create_users#confirm_set_up'
        get :set_up_confirmation
      end

      member do
        get :edit, to: 'edit_users#edit'
        patch :update, to: 'edit_users#update'
        get :remove, to: 'remove_users#remove'
        post :remove, to: 'remove_users#confirm_remove'
      end
    end
  end

  scope module: 'account_details', path: '/' do
    get :edit_password, to: 'passwords#edit'
    patch :edit_password, to: 'passwords#update'

    get :primary_users_account_details, to: 'primary_users#primary_account_details'
    resources :primary_users, only: %i[] do
      collection do
        scope controller: 'organisation_names' do
          get :edit_name
          get :update_name
        end

        scope controller: 'emails' do
          get :edit_email
          post :update_email
          get :email_sent
          get :resend_email
          get :confirm_email
          get :validate_confirm_email
        end
      end
    end

    scope controller: 'account_cancellations' do
      get :account_closing_notice
      post :account_closing_notice, to: 'account_cancellations#confirm_account_closing_notice'
      get :account_cancellation
      post :account_cancellation, to: 'account_cancellations#submit_account_cancellation'
      get :account_closed
    end

    get :non_primary_users_account_details, to: 'non_primary_users#non_primary_account_details'
    resources :non_primary_users, only: %i[] do
      collection do
        scope controller: 'names' do
          get :edit_name
          get :update_name
        end
      end
    end
  end

  scope module: 'payment_history', path: '/', controller: 'payment_history' do
    get :payment_history
    get :payment_history_details
  end

  scope controller: 'static_pages' do
    get :accessibility_statement
    get :cookies
    get :help
    get :privacy_notice
    get :terms_and_conditions
  end

  scope controller: 'application' do
    get :build_id
    get :health
  end

  scope controller: 'errors' do
    get :not_found
    get :service_unavailable
  end

  scope controller: 'relevant_portal' do
    get :what_would_you_like_to_do
    post :what_would_you_like_to_do, to: 'relevant_portal#submit_what_would_you_like_to_do'
  end

  match '/404', to: 'errors#not_found', via: :all
  match '/422', to: 'errors#internal_server_error', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all
  match '/503', to: 'errors#service_unavailable', via: :all
end
