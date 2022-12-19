Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  get 'admin/dashboard'
  get 'call', to: 'call#user', as: 'call_user'
  post 'call', to: 'call#create'

  resources :publishes do
    collection do
      post 'likes/:id', to: 'publishes#likes_publish', as: :likes
      get 'user_publish/:id', to: 'publishes#user_publish', as: :user_publish 
    end
  end

  resources :rooms do
    resources :messages
    collection do
      post :search
    end
  end
  # leave_room_path(room)
  get 'rooms/leave/:id', to: 'rooms#leave', as: 'leave_room'
  # join_room_path(room)
  get 'rooms/join/:id', to: 'rooms#join', as: 'join_room'

  root 'publishes#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get 'user/:id', to: 'users#show', as: 'user'
  # Defines the root path route ("/")
  # root "articles#index"
end
