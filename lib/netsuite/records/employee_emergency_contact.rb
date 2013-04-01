module NetSuite
  module Records
    class EmployeeEmergencyContact
      include Support::Fields
      include Support::Records
      include Support::Actions
      include Namespaces::ListEmp

      actions :get, :add, :delete, :update

      fields :id, :contact, :relationship, :address, :phone

      def initialize(attributes_or_record = {})
        case attributes_or_record
        when self.class
          initialize_from_record(attributes_or_record)
        when Hash
          attributes_or_record = attributes_or_record[:employee_emergency_contact] if attributes_or_record[:employee_emergency_contact]
          initialize_from_attributes_hash(attributes_or_record)
        end
      end

      def initialize_from_record(obj)
        self.id               = obj.id
        self.contact          = obj.degree_date
        self.relationship     = obj.relationship
        self.address          = obj.address
        self.phone            = obj.phone
      end

    end
  end
end
