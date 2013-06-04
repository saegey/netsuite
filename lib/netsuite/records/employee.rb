module NetSuite
  module Records
    class Employee
      include Support::Fields
      include Support::RecordRefs
      include Support::Records
      include Support::Actions
      include Namespaces::ListEmp

      actions :get, :add, :delete, :update, :search, :get_select_value

      fields :entity_id, :salutation, :first_name, :middle_name, :last_name, :title, :phone, :fax, :email,
             :default_address, :is_inactive, :phonetic_name, :alt_email, :initials, :office_phone, :home_phone,
             :mobile_phone, :account_number, :comments, :user_perquest, :adp_id, :direct_deposit, :expense_limit,
             :purchase_order_limit, :purchase_order_approval_limit, :social_security_number, :approval_limit,
             :is_sales_rep, :is_support_rep, :is_job_resource, :labor_cost, :birth_date, :hire_date, :release_date,
             :last_review_date, :next_review_date, :title, :job_description, :give_access, :concurrent_web_services_user,
             :send_email, :has_offline_access, :password, :password2, :require_pwd_change, :inherit_ip_rules,
             :ip_address_rule, :bill_pay, :eligible_for_commission

      # field :subscriptions_list, EmployeeSubscriptionsList
      field :addressbook_list,  EmployeeAddressbookList
      field :roles_list, EmployeeRolesList
      # field :hr_education_list, EmployeeHrEducationList
      field :emergency_contact_list, EmployeeEmergencyContactList
      field :custom_field_list, CustomFieldList
      # field :accrued_time_list, EmployeeAccruedTimeList
      # field :direct_deposit_list, EmployeeDirectDepositList
      # field :company_contribution_list, EmployeeCompanyContributionList
      # field :earning_list, EmployeeEarningList
      # field :deduction_list, EmployeeDeductionList
      # field :pay_frequency, EmployeePayFrequency
      # field :use_time_data, EmployeeUseTimeData
      # field :gender, Gender
      # field :commission_payment_preference, EmployeeCommissionPaymentPreference

      read_only_fields :last_modified_date, :date_created

      record_refs :custom_form, :template, :department, :klass, :location, :supervisor, :approver,
                  :employee_type, :employee_status, :workplace, :purchase_order_approver, :time_approver,
                  :subsidiary, :billing_class, :image, :currency, :sales_roles, :ethnicity, :work_calendar

      attr_reader   :internal_id
      attr_accessor :external_id

      def initialize(attributes = {})
        @internal_id = attributes.delete(:internal_id) || attributes.delete(:@internal_id)
        @external_id = attributes.delete(:external_id) || attributes.delete(:@external_id)
        initialize_from_attributes_hash(attributes)
      end

      def to_record
        rec = super
        if rec["#{record_namespace}:customFieldList"]
          rec["#{record_namespace}:customFieldList!"] = rec.delete("#{record_namespace}:customFieldList")
        end
        rec
      end

    end
  end
end
