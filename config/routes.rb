Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  require 'resque/server'
  mount Resque::Server, at: '/admin/jobs'

  namespace :api do
    namespace :v1 do
        resources :short_urls, only: [:index, :create, :show]
        get '/urls/:short_code' => 'short_urls#show'
        post '/urls' => 'short_urls#create'
        get '/urls' => 'short_urls#index'
    end
  end

end
