require 'rack/session/abstract/id'

module Rack
  module Session
    class CookieStore < Abstract::ID
      VERSION = "0.1.1"
    end
  end
end