require 'devise/oauth2_providable/strategies/oauth2_grant_type_strategy'

module Devise
  module Strategies
    class Oauth2RefreshTokenGrantTypeStrategy < Oauth2GrantTypeStrategy
      def grant_type
        'refresh_token'
      end

      def authenticate_grant_type(client)
        if refresh_token = client.refresh_tokens.find_by_token(params[:refresh_token])
          env[Devise::Oauth2Providable::REFRESH_TOKEN_ENV_REF] = refresh_token
          success! refresh_token.user
        else
          if resource.blank?
            oauth_error! :invalid
          else
            oauth_error! resource.unauthenticated_message
          end
        end
      end
    end
  end
end

Warden::Strategies.add(:oauth2_refresh_token_grantable, Devise::Strategies::Oauth2RefreshTokenGrantTypeStrategy)
