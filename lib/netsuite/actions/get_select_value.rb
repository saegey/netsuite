module NetSuite
  module Actions
    class GetSelectValue
      include Support::Requests

      def initialize(klass, options = {})
        @klass   = klass
        @options = options
      end

      private

      def request
        NetSuite::Configuration.connection(
          namespaces: {
            'xmlns:platformMsgs' => "urn:messages_#{NetSuite::Configuration.api_version}.platform.webservices.netsuite.com",
            'xmlns:platformCore' => "urn:core_#{NetSuite::Configuration.api_version}.platform.webservices.netsuite.com",
            'xmlns:platformCoreTyp' => "urn:types.core_#{NetSuite::Configuration.api_version}.platform.webservices.netsuite.com"
          },
        ).call :get_select_value, message: request_body#, message_tag: :platformMsgs
      end

      def soap_type
        @klass.to_s.split('::').last.lower_camelcase
      end

      # <soapenv:Body>
      #    <platformMsgs:getSelectValue
      #        xmlns:platformMsgs="urn:messages_2012_2.platform.webservices.netsuite.com"
      #        xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/"
      #        xmlns:xsd="http://www.w3.org/2001/XMLSchema"
      #        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      #        xmlns:platformCore="urn:core_2012_2.platform.webservices.netsuite.com"
      #        xmlns:platformCoreTyp="urn:types.core_2012_2.platform.webservices.netsuite.com">
      #       <platformMsgs:fieldDescription>
      #          <platformCore:recordType>employee</platformCore:recordType>
      #          <platformCore:sublist>rolesList</platformCore:sublist>
      #          <platformCore:field>selectedRole</platformCore:field>
      #       </platformMsgs:fieldDescription>
      #       <platformMsgs:pageIndex>0</platformMsgs:pageIndex>
      #    </platformMsgs:getSelectValue>
      # </soapenv:Body>

      def request_body
        body = {
          ':fieldDescription' => {
            'platformCore:recordType' => soap_type,
            'platformCore:sublist' => @options[:sublist],
            'platformCore:field' => @options[:field],
            'platformCore:filterByValueList' => {
              'platformCore:filterBy' => {
                'platformCore:field' => '',
                'platformCore:internalId' => ''
              }
            }
          },
          ':pageIndex' => 0
        }
        body
      end

      def response_header
        @response_header ||= response_header_hash
      end

      def response_header_hash
        @response_header_hash = @response.header[:document_info]
      end

      def response_body
        @response_body ||= get_select_value_result
      end

      def get_select_value_result
        @get_select_value_result = @response.body[:get_select_value_response][:get_select_value_result]
      end

      def success?
        puts get_select_value_result
        @success ||= get_select_value_result[:status][:@is_success] == 'true'
      end

      module Support

        def self.included(base)
          base.extend(ClassMethods)
        end

        module ClassMethods

          def get_select_value(options = {})
            options = { :internal_id => options } unless options.is_a?(Hash)

            response = NetSuite::Actions::GetSelectValue.call(self, options)
            if response.success?
              response.body
            else
              raise StandardError, "#{self} with OPTIONS=#{options.inspect} could not be found"
            end
          end

        end
      end

    end
  end
end
