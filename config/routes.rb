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
    
  get 'web_forms/:id/submissions' => 'web_forms#submissions', as: 'submissions'
  get 'web_forms/:id/embed_code' => 'web_forms#embed_code', as: 'form_embed'

  namespace :api do
    get "submit/:id" => "submissions_entries#create"
  end
    
end
