module NetSuite
  module Records
    class EmployeeAddressbookList
      include Namespaces::ListEmp

      def initialize(attributes = {})
        case attributes[:addressbook]
        when Hash
          addressbooks << EmployeeAddressbook.new(attributes[:addressbook])
        when Array
          attributes[:addressbook].each { |addressbook| addressbooks << EmployeeAddressbook.new(addressbook) }
        end
      end

      def addressbooks
        @addressbooks ||= []
      end

      def to_record
        { "#{record_namespace}:addressbook" => addressbooks.map(&:to_record) }
      end

    end
  end
end
