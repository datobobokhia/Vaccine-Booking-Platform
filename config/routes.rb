require 'sidekiq/web'
Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  scope '(:locale)', locale: /#{I18n.available_locales.join("|")}/ do
    root to: 'main#index'

  devise_for :users
    namespace :admin do
      root to: 'main#index'
      resources :users
      resources :vaccines_items
      resources :bookings
      resources :patients
      resources :business_units
      resources :business_unit_slots
      resources :districts
      get '/countries/fetch_cities'
      resources :countries
      get '/cities/fetch_districts'
      resources :cities
      resources :orders
      resources :sms
    end
  end

  get 'slots/fetch_cities'
  get 'slots/fetch_districts'
  get 'slots/fetch_business_units'
  resources :slots, only: [:index]

  match 'bookings/:vaccine', to: 'main#current_step', via: :get, as: :current_step
  match 'next_step', to: 'main#next_step', via: :post
  match 'prev_step', to: 'main#prev_step', via: :post

  get 'cancel_my_order/find_user_order'
  post 'cancel_my_order/send_user_verification'
  post 'cancel_my_order/verify_user_code'
  resources :cancel_my_order

end
