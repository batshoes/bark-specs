Rails.application.routes.draw do
  root to: "home#index"
  get "/log-in" => "sessions#new", as: :log_in
  post "/log-in" => "sessions#create"
  delete "/log-out" => "sessions#destroy", as: :log_out
  #get '/statuses' => "statuses#index", as: :statuses

  resources :statuses

  resources :dogs do
    resources :statuses
  end
  get "/profile" => "dogs#profile", as: :profile
end
