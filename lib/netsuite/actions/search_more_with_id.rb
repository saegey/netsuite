# TODO: Tests
# TODO: DBC
module NetSuite
  module Actions
    class SearchMoreWithId
      include Support::Requests

      def initialize(klass, options = { })
        @klass = klass

        @options = options
      end

      private

      def request
        # https://system.netsuite.com/help/helpcenter/en_US/Output/Help/SuiteFlex/WebServices/STP_SettingSearchPreferences.html#N2028598271-3
        preferences = NetSuite::Configuration.auth_header
        preferences = preferences.merge((@options[:preferences] || {}).inject({}) do |h, (k, v)|
          h[k.to_s.lower_camelcase] = v
          h
        end)

        NetSuite::Configuration.connection(
          namespaces: {
            'xmlns:platformMsgs' => "urn:messages_#{NetSuite::Configuration.api_version}.platform.webservices.netsuite.com",
            'xmlns:platformCore' => "urn:core_#{NetSuite::Configuration.api_version}.platform.webservices.netsuite.com",
            'xmlns:platformCommon' => "urn:common_#{NetSuite::Configuration.api_version}.platform.webservices.netsuite.com",
            'xmlns:listRel' => "urn:relationships_#{NetSuite::Configuration.api_version}.lists.webservices.netsuite.com",
            'xmlns:listEmp' => "urn:employees_#{NetSuite::Configuration.api_version}.lists.webservices.netsuite.com",
            'xmlns:tranSales' => "urn:sales_#{NetSuite::Configuration.api_version}.transactions.webservices.netsuite.com",
          },
          soap_header: preferences
        ).call :search_more_with_id, :message => request_body
      end

      # TODO: Consistent use of namespace qualifying
      def request_body
        buffer = ''

        xml = Builder::XmlMarkup.new(target: buffer)

        xml.platformMsgs(:searchId, @options[:search_id])
        xml.platformMsgs(:pageIndex, @options[:page].present? ? @options[:page] : 2)

        buffer
      end

      def response_header
        @response_header ||= response_header_hash
      end

      def response_header_hash
        @response_header_hash = @response.header[:document_info]
      end

      def response_body
        @response_body ||= search_result
      end

      def search_result
        @search_result = @response.body[:search_more_with_id_response][:search_result]
      end

      def success?
        @success ||= search_result[:status][:@is_success] == 'true'
      end

      # TODO: Refactor
      def more?
        @more ||= response_body_hash[:page_index] < response_body_hash[:total_pages]
      end

      module Support
        def self.included(base)
          base.extend(ClassMethods)
        end

        # TODO: Rename page_index to page
        module ClassMethods
          # Preconditions
          # => options[:search_id] is a string
          # => options[:page], optional, is an integer
          # Postconditions
          # => Hash with the following keys:
          #      * page_index which is an integer
          #      * total_pages which is an integer
          #      * search_results containing array of SearchResult's
          def search_more_with_id(options = { })
            response = NetSuite::Actions::SearchMoreWithId.call(self, options)

            response_hash = { }

            if response.success?
              NetSuite::Support::SearchResult.new(response, self)
            else
              false
            end
          end
        end
      end
    end
  end
end
