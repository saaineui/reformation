Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'sessions/new'
  get 'signup' => 'users#new'

  root 'landing#home'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'

  resources :users
  get 'users/:id/token_check/:nickname' => 'users#token_check', as: 'token_check'

  resources :web_forms, only: %i[new create show edit update destroy]
  resources :submissions, only: %i[destroy]
    
  get 'web_forms/:id/submissions' => 'web_forms#submissions', as: 'submissions'
  get 'web_forms/:id/embed_code' => 'web_forms#embed_code', as: 'form_embed'

  namespace :api do
    resources :web_forms, only: []  do
      resources :submissions, only: %i[create]
    end
  end
  
  ## temp lee stuff
  get 'share' => 'landing#share'
  get 'amicus' => 'landing#share'
end
