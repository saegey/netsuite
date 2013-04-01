module NetSuite
  module Records
    class EmployeeHrEducation
      include Support::Fields
      include Support::RecordRefs
      include Support::Records
      include Namespaces::ListEmp

      fields :degree, :degree_date

      record_refs :education

      def initialize(attributes_or_record = {})
        case attributes_or_record
        when self.class
          initialize_from_record(attributes_or_record)
        when Hash
          attributes_or_record = attributes_or_record[:hr_education] if attributes_or_record[:hr_education]
          initialize_from_attributes_hash(attributes_or_record)
        end
      end

      def initialize_from_record(obj)
        self.degree           = obj.degree
        self.degree_date      = obj.degree_date
      end

    end
  end
end
