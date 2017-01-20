Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'sessions/new'
  get 'signup' => 'users#new'

  root 'landing#home'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'

  resources :users
  get 'users/:id/token_check' => 'users#token_check', as: 'token_check'

  resources :web_forms, only: [:new, :create, :show, :edit, :update, :destroy]

end
