# frozen_string_lateral: true

# Routes for V1 of API
namespace :api do
    namespace :v1 do
        scope :users, module: :users do
            # Register new User
            post '/', to: 'registrations#create', as: :user_registration
        end

        resources :books
    end
end


# Scope for V1 of API
scope :api do
    scope :v1 do
        use_doorkeeper do
            skip_controllers :authorizations, :applications, :authorized_applications
        end
    end
end