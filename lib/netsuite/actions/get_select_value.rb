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
        connection.request :platformMsgs, :get_select_value do
          soap.namespaces['xmlns:platformMsgs'] = "urn:messages_#{NetSuite::Configuration.api_version}.platform.webservices.netsuite.com"
          soap.namespaces['xmlns:platformCore'] = "urn:core_#{NetSuite::Configuration.api_version}.platform.webservices.netsuite.com"
          soap.header = auth_header
          soap.body   = request_body
        end
      end

      def soap_type
        @klass.to_s.split('::').last.lower_camelcase
      end

      # <soap:Body>
      #   <getSelectValue xmlns="urn:messages_2009_2.platform.webservices.netsuite.com">
      #    <fieldDescription>
      #     <ns6:recordType xmlns:ns6="urn:core_2009_2.platform.webservices.netsuite.com">salesOrder<
      #        ns6:recordType>
      # <ns7:sublist xmlns:ns7="urn:core_2009_2.platform.webservices.netsuite.com">itemList</ns7:sublist>
      # <ns8:field xmlns:ns8="urn:core_2009_2.platform.webservices.netsuite.com">item</ns8:field>
      # <ns9:filterByValueList xmlns:ns9="urn:core_2009_2.platform.webservices.netsuite.com">
      #      <ns9:filterBy>
      #       <ns9:field>entity</ns9:field>
      #       <ns9:internalId>8</ns9:internalId>
      #      </ns9:filterBy>
      #     </ns9:filterByValueList>
      #    </fieldDescription>
      #    <pageIndex>1</pageIndex>
      #   </getSelectValue>
      #  </soap:Body>
      def request_body
        body = {
          ':fieldDescription' => {
            'platformCore:recordType' => 'employee',
            'platformCore:sublist' => 'rolesList',
            'platformCore:field' => 'roles',
            'platformCore:filterByValueList' => {
              'platformCore:filterBy' => {
                'platformCore:field' => '',
                'platformCore:internalId' => ''
              }
            }
          },
          ':pageIndex' => 1
        }
        # body[:attributes!]['fieldDescription']['externalId'] = @options[:external_id] if @options[:external_id]
        # body[:attributes!]['fieldDescription']['internalId'] = @options[:internal_id] if @options[:internal_id]
        # body[:attributes!]['fieldDescription']['typeId']     = @options[:type_id]     if @options[:type_id]
        # body[:attributes!]['fieldDescriptionf']['type']       = soap_type              unless @options[:custom]
        body
      end

      def success?
        @success ||= response_hash[:status][:@is_success] == 'true'
      end

      def response_body
        @response_body ||= response_hash[:record]
      end

      def response_hash
        @response_hash = @response[:get_response][:read_response]
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
             new(response.body)
            else
             raise RecordNotFound, "#{self} with OPTIONS=#{options.inspect} could not be found"
            end
          end

        end
      end

    end
  end
end
