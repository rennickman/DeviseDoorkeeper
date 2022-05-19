# frozen_string_literal: true

module DoorkeeperRegisterable
    extend ActiveSupport::Concern

    def generate_refresh_token
        loop do
            # Generate a random token string and return it - unless there is already another token with the same string
            token = SecureRandom.hex(32)
            break token unless Doorkeeper::AccessToken.exists?(refresh_token: token)
        end
    end


    def render_user(user, client_app, token_type = "Bearer")
        # Create access token from Doorkeeper
        access_token = Doorkeeper::AccessToken.create(
            resource_owner_id: user.id,
            refresh_token: generate_refresh_token,
            expires_in: Doorkeeper.configuration.access_token_expires_in.to_i,
            scopes: ""
        )

        # Return User Information format
        {
            id: user.id,
            access_token: access_token.token,
            token_type: token_type,
            expires_in: access_token.expires_in,
            refresh_token: access_token.refresh_token,
            created_at: access_token.created_at.to_time.to_i
        }
    end
end