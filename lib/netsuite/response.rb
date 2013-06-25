module NetSuite
  class Response
    attr_accessor :header, :body, :response

    def initialize(attributes = {})
      @success  = attributes[:success]
      @header   = attributes[:header]
      @body     = attributes[:body]
      @response = attributes[:response]
    end

    def success!
      @success = true
    end

    def success?
      @success
    end

  end
end
