# frozen_string_literal: true

Rails.application.routes.draw do
  get 'welcome/index'
  root 'welcome#index'

  resources :vehicle_checkers, only: [] do
    collection do
      get :enter_details
      post :enter_details, to: 'vehicle_checkers#submit_details'
      get :confirm_details
      get :incorrect_details
      get :user_confirm_details
      get :number_not_found
      get :exemption
      get :cannot_determinate
      get :non_uk
    end
  end

  resources :air_zones, only: [] do
    collection do
      get :caz_selection
      post :compliance
      get :compliance, to: redirect('air_zones/caz_selection')
    end
  end

  resources :contact_forms, only: :index do
    collection do
      post :index, to: 'contact_forms#validate'
      get :result
    end
  end

  get :service_unavailable, to: 'application#server_unavailable'
  get :health, to: 'application#health'
  get :build_id, to: 'application#build_id'
  get :cookies, to: 'cookies#index'
  get :privacy_notice, to: 'privacy_notice#index'

  match '/404', to: 'errors#not_found', via: :all
  # There is no 422 error page in design systems
  match '/422', to: 'errors#internal_server_error', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all
  match '/503', to: 'errors#service_unavailable', via: :all
end
