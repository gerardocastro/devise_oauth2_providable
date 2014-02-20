require 'devise/strategies/base'

module Devise
  module Strategies
    class Oauth2GrantTypeStrategy < Authenticatable
      def valid?
        params[:controller] == 'devise/oauth2_providable/tokens' && request.post? && params[:grant_type] == grant_type
      end

      # defined by subclass
      def grant_type
      end

      # defined by subclass
      def authenticate_grant_type(client)
      end

      def authenticate!
        client_id, client_secret = request.authorization ? decode_credentials : [params[:client_id], params[:client_secret]]
        client = Devise::Oauth2Providable::Client.find_by_identifier client_id
        if client && client.secret == client_secret
          env[Devise::Oauth2Providable::CLIENT_ENV_REF] = client
          authenticate_grant_type(client)
        else
          oauth_error! :invalid
        end
      end
    end
  end
end
