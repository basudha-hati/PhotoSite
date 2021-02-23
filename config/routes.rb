Rails.application.routes.draw do
  resources :posts
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/index' => 'user#index'
  get '/photo/index/id' => 'photo#index'
end
