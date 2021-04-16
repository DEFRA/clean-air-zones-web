# frozen_string_literal: true

Rails.application.routes.draw do
  scope controller: 'application' do
    get :build_id, constraints: { format: :json }, defaults: { format: :json }
    get :health, constraints: { format: :json }, defaults: { format: :json }
  end

  constraints(CheckRequestFormat) do
    get 'welcome/index'
    root 'welcome#index'

    resources :vehicle_checkers, only: [] do
      collection do
        get :enter_details
        post :enter_details, to: 'vehicle_checkers#submit_details'
        get :confirm_details
        post :confirm_details, to: 'vehicle_checkers#submit_confirm_details'
        get :confirm_uk_details
        post :confirm_uk_details, to: 'vehicle_checkers#submit_confirm_uk_details'
        get :incorrect_details
        get :number_not_found
        get :exemption
        get :cannot_determine
        get :non_uk
      end
    end

    resources :air_zones, only: [] do
      collection do
        get :compliance
        get :non_uk_compliance
      end
    end

    scope controller: 'static_pages' do
      get :accessibility_statement
      get :cookies
      get :privacy_notice
    end

    get :service_unavailable, to: 'application#server_unavailable'

    match '/404', to: 'errors#not_found', via: :all
    match '/422', to: 'errors#internal_server_error', via: :all
    match '/500', to: 'errors#internal_server_error', via: :all
    match '/503', to: 'errors#service_unavailable', via: :all
  end
  # renders not found page for all unsupported type requests
  match '*unmatched', to: 'errors#not_found', via: :all
end
