Rails.application.routes.draw do

    # Devise User Routes
    devise_for :users

    resources :books


    # Defines the root path route ("/")
    root "pages#home"
end
