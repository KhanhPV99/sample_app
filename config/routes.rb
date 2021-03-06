Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get :home, to: "static_pages#home"
    get :help, to: "static_pages#help"
    get :login, to: "sessions#new"
    post :login, to: "sessions#create"
    delete :logout, to: "sessions#destroy"
    get "password_resets/new"
    get "password_resets/edit"

    resources :users
    resources :account_activations, only: :edit
    resources :password_resets, except: %i(index show destroy)
  end
end
