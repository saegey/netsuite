module NetSuite
  module Support
    module Requests

      def self.included(base)
        base.send(:extend, ClassMethods)
      end

      module ClassMethods

        def call(*args)
          new(*args).call
        end

      end

      def call
        @response = request
        build_response
      end

      private

      def request
        raise NotImplementedError, 'Please implement a #request method'
      end

      def build_response
        Response.new(:success => success?, header: @response.header, :body => @response.body)
      end

      def success?
        raise NotImplementedError, 'Please implement a #success? method'
      end

      # Only care about headers in Search class for now
      def response_header
        @response.header
      end

      def response_body
        @response
        # raise NotImplementedError, 'Please implement a #response_body method'
      end

    end
  end
end
