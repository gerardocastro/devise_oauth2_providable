require 'devise/strategies/base'
require 'devise/oauth2_providable/custom_authenticatable_error'

module Devise
  module Strategies
    class Oauth2Providable < Oauth2GrantTypeStrategy
      def valid?
        @req = Rack::OAuth2::Server::Resource::Bearer::Request.new(env)
        @req.oauth2?
      end

      def authenticate!
        @req.setup!
        token = Devise::Oauth2Providable::AccessToken.find_by_token @req.access_token
        env[Devise::Oauth2Providable::CLIENT_ENV_REF] = token.client if token
        resource = token ? token.user : nil
        if validate(resource)
          success! resource
        else
          oauth_error! :invalid
        end
      end
    end
  end
end

Warden::Strategies.add(:oauth2_providable, Devise::Strategies::Oauth2Providable)
