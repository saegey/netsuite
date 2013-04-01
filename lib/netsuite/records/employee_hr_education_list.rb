module NetSuite
  module Records
    class EmployeeHrEducationList
      include Namespaces::ListEmp

      def initialize(attributes = {})
        case attributes[:employee_hr_education]
        when Hash
          employee_hr_educations << EmployeeHrEducations.new(attributes[:employee_hr_education])
        when Array
          attributes[:employee_hr_education].each { |employee_hr_education| employee_hr_educations << EmployeeHrEducation.new(employee_hr_education) }
        end
      end

      def employee_hr_educations
        @employee_hr_educations ||= []
      end

      def to_record
        { "#{record_namespace}:hr_education" => employee_hr_education.map(&:to_record) }
      end
    end
  end
end
