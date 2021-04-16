# frozen_string_literal: true

Rails.application.routes.draw do
  scope controller: 'application' do
    get :build_id, constraints: { format: :json }, defaults: { format: :json }
    get :health, constraints: { format: :json }, defaults: { format: :json }
  end

  constraints(CheckRequestFormat) do
    devise_for :users, controllers: { sessions: 'sessions' }

    authenticated(:user) { root 'sidebar/upload#index', as: :authenticated_root }
    devise_scope(:user) { root to: 'devise/sessions#new' }

    scope module: 'sidebar', path: '/' do
      resources :upload, only: %i[] do
        collection do
          post :import
          get :processing
          get :data_rules
        end
      end

      resources :vehicles do
        collection do
          get :search
          post :search, to: 'vehicles#submit_search'
          get :historic_search
          get :add
          post :add, to: 'vehicles#create'
          get :remove, to: 'remove_vehicles#remove'
          post :remove, to: 'remove_vehicles#submit_remove'
          get :confirm_remove, to: 'remove_vehicles#confirm_remove'
          post :confirm_remove, to: 'remove_vehicles#delete'
          get :export, to: 'csv_exports#export'
          get :download_csv, to: 'csv_exports#download_csv'
        end
      end
    end

    resources :passwords, only: %i[new create] do
      collection do
        get '/', to: redirect('/')
        get :success
        get :reset
        post :send_confirmation_code
        get :confirm_reset
        post :change
      end
    end

    resources :cookies, only: :index

    get :service_unavailable, to: 'errors#service_unavailable'

    match '/404', to: 'errors#not_found', via: :all
    match '/422', to: 'errors#internal_server_error', via: :all
    match '/500', to: 'errors#internal_server_error', via: :all
    match '/503', to: 'errors#service_unavailable', via: :all
  end
  # renders not found page for all unsupported type requests
  match '*unmatched', to: 'errors#not_found', via: :all
end
