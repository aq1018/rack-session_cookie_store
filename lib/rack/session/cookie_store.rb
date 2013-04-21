require 'digest'
require 'rack/request'
require 'rack/response'
require 'rack/session/abstract/id'
require 'rack/session/cookie_store/version'

module Rack
  module Session
    class CookieStore < Abstract::ID
      class Signer
        def sign(data, secret)
          "s:#{data}.#{digest(data, secret)}"
        end

        def unsign(data, secret)
          return nil unless data[0..1] == 's:'
          str = data[2..-1]
          str = str[0...str.rindex('.')]
          return nil unless sign(str, secret) == data
          str
        end

      private
        def digest(data, secret)
          Digest::HMAC.base64digest(data, secret, Digest::SHA256).gsub /\=+$/, ''
        end
      end

      class Marshal
        def dump(hash)
          "j:#{JSON.dump(hash)}"
        end

        def load(str)
          return nil unless str [0..1] == 'j:'
          JSON.parse(str[2..-1])
        rescue
          nil
        end
      end

      def initialize(app, options)
        @secret = options[:secret]
        @marshal  = options[:marshal] ||= Marshal.new
        @signer = options[:signer] ||= Signer.new

        super(app, options.merge!(:cookie_only => true))
      end

      private

      attr_reader :marshal, :signer

      def load_session(env)
        data = unpacked_cookie_data(env)
        data = persistent_session_id!(data)
        p "load session"
        p data
        [data["session_id"], data]
      end

      def unpacked_cookie_data(env)
        env["rack.session.unpacked_cookie_data"] ||= begin
          request = Rack::Request.new(env)
          str = signer.unsign(request.cookies[@key], @secret)
          marshal.load(str) || {}
        end
      end

      def extract_session_id(env)
        unpacked_cookie_data(env)["session_id"]
      end

      def persistent_session_id!(data, sid=nil)
        data ||= {}
        data["session_id"] ||= sid || generate_sid
        data
      end

      def set_cookie(env, headers, cookie)
        Utils.set_cookie_header!(headers, @key, cookie)
      end

      def set_session(env, session_id, session, options)
        session = session.merge("session_id" => session_id)
        session_data = signer.sign(marshal.dump(session), @secret)

        p "set session"
        p session
        p session_data

        if session_data.size > (4096 - @key.size)
          env["rack.errors"].puts("Warning! Rack::Session::Cookie data size exceeds 4K.")
          nil
        else
          session_data
        end
      end

      def destroy_session(env, session_id, options)
        # Nothing to do here, data is in the client
        generate_sid unless options[:drop]
      end
    end
  end
end

