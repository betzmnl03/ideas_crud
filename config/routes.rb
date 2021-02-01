Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

root "ideas#index"
resources :ideas do
  resources :likes, shallow: true, only: [:create, :destroy]
  get :liked, on: :collection
  resources :joins, shallow: true, only: [:create, :destroy]
  get :joined, on: :collection
  resources :reviews
end

resources :users, only:[:new, :create]
resource :session, only:[:new, :create, :destroy]

end
