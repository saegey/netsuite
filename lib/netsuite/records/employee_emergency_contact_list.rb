module NetSuite
  module Records
    class EmployeeEmergencyContactList
      include Namespaces::ListEmp

      def initialize(attributes = {})
        case attributes[:employee_emergency_contact]
        when Hash
          addressbooks << EmployeeEmergencyContact.new(attributes[:employee_emergency_contact])
        when Array
          attributes[:employee_emergency_contact].each { |employee_emergency_contact| employee_emergency_contacts << EmployeeEmergencyContact.new(employee_emergency_contact) }
        end
      end

      def employee_emergency_contacts
        @employee_emergency_contacts ||= []
      end

      def to_record
        { "#{record_namespace}:employee_emergency_contact" => employee_emergency_contacts.map(&:to_record) }
      end

    end
  end
end
