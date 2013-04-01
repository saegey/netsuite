module NetSuite
  module Records
    class EmployeeRolesList
      include Namespaces::ListEmp

      def initialize(attributes = {})
        case attributes[:roles]
        when Hash
          roles << EmployeeRoles.new(attributes[:roles])
        when Array
          attributes[:roles].each { |role| roles << EmployeeRoles.new(role) }
        end
      end

      def roles
        @roles ||= []
      end

      def to_record
        { "#{record_namespace}:roles" => roles.map(&:to_record) }
      end

    end
  end
end
