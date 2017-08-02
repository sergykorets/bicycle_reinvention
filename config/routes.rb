Rails.application.routes.draw do

  devise_for :authors, :controllers => { registrations: 'registrations' }
  root to: 'blog/bicycles#index'

  namespace :authors do
    resources :categories, only: [:new, :create, :edit, :update, :destroy]
  	resources :bicycles do
      get :disliked, on: :collection
      post :like, on: :member
      resources :comments, only: :index
        member do 
          put 'publish' => 'bicycles#publish'
          put 'unpublish' => 'bicycles#unpublish'
        end
    end
  end

  namespace :blog do
    resources :categories, only: [:index, :show]
    resources :bicycles, only: [:show, :index] do
      resources :comments, except: [:edit, :update, :show]
      post :dislike, on: :member
    end
  end
  scope module: 'blog' do
  	get 'bicycles' => 'bicycles#index', as: :bicycles
  	get 'bicycles/:id' => 'bicycles#show', as: :post
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
