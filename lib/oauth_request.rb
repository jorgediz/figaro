require "rubygems"
require "oauth"
require "request"

module Figaro

  class OauthRequest < Request

    def site(value) @site = "http://#{value}.com" end
    def consumer_key(value) @consumer_key = value end
    def consumer_secret(value) @consumer_secret = value end
    def oauth_token(value) @token = value end
    def oauth_secret(value) @secret = value end

    def consumer
      OAuth::Consumer.new(
        @consumer_key,
        @consumer_secret,
        {
          :site => @site,
          :scheme => :header
        }
      )
    end

    def token_hash
      {
        :oauth_token => @token,
        :oauth_token_secret => @secret
      }
    end

    def get_request_token
      @sut = consumer.get_request_token
    end

    def request_token
      OAuth::RequestToken.from_hash consumer, token_hash
    end

    def get_access_token(pin)
      @sut = request_token.get_access_token :oauth_verifier => pin
    end

    def access_token
      OAuth::AccessToken.from_hash consumer, token_hash
    end

    def get(resource)
      @sut = access_token.request :get, "#{@url}/#{resource}"
    end

    def post_to(content, resource)
      @sut = access_token.request :post, "#{@url}/#{resource}", content, @options
    end

    def post(resource)
      @sut = access_token.request :post, "#{@url}/#{resource}", @options
    end

  end

end