module Api
    module V1
        module Users
            class RegistrationsController < ApiController
                # Skip doorkeeper authorization because we dont expect user to be logged in
                skip_before_action :doorkeeper_authorize!, only: %i [create]

                include DoorkeeperRegisterable



                def create
                    # Create Client Application using Doorkeeper
                    client_app = Doorkeeper::Application.find_by(uid: params[:client_id])

                    # Send error message is Client Application not created
                    unless client_app
                        return render json: {
                            error: I18n.t('doorkeeper.errors.messages.invalid_client'),
                            status: unauthorized
                        }
                    end

                    # Remove Client Id from allowed params
                    allowed_params = user_params.except(:client_id)
                    # Create new user
                    user = User.new(allowed_params)

                    if user.save
                        # Return user if it was saved
                        render.json: render_user(user, client_app), status: :ok
                    else 
                        # Return error message if User couldnt be saved
                        render json: { errors: user.errors }, status: :unprocessable_entity
                end



                private


                def user_params
                    params.permit(:email, :password, :client_id)
                end
            end
        end
    end
end