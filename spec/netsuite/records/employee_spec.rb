require 'spec_helper'

describe NetSuite::Records::Employee do
  let(:employee) { NetSuite::Records::Employee.new }

  it 'has all the right fields' do
    [
      :entity_id, :salutation, :first_name, :middle_name, :last_name, :title, :phone, :fax, :email,
      :default_address, :is_inactive, :phonetic_name, :alt_email, :initials, :office_phone, :home_phone,
      :mobile_phone, :account_number, :comments, :user_perquest, :adp_id, :direct_deposit, :expense_limit,
      :purchase_order_limit, :purchase_order_approval_limit, :social_security_number, :approval_limit,
      :is_sales_rep, :is_support_rep, :is_job_resource, :labor_cost, :birth_date, :hire_date, :release_date,
      :last_review_date, :next_review_date, :title, :job_description, :give_access, :concurrent_web_services_user,
      :send_email, :has_offline_access, :password, :password2, :require_pwd_change, :inherit_ip_rules,
      :ip_address_rule, :bill_pay, :eligible_for_commission
    ].each do |field|
      employee.should have_field(field)
    end
  end

  it 'has the right record_refs' do
    [
      :custom_form, :template, :department, :klass, :location, :supervisor, :approver,
      :employee_type, :employee_status, :workplace, :purchase_order_approver, :time_approver,
      :subsidiary, :billing_class, :image, :currency, :sales_roles, :ethnicity, :work_calendar
    ].each do |record_ref|
      employee.should have_record_ref(record_ref)
    end
  end

  describe '#addressbook_list' do
    it 'can be set from attributes' do
      employee.addressbook_list = {
        :addressbook => {
          :addr1            => '123 Happy Lane',
          :addr_text        => "123 Happy Lane\nLos Angeles CA 90007",
          :city             => 'Los Angeles',
          :country          => '_unitedStates',
          :default_billing  => true,
          :default_shipping => true,
          :internal_id      => '567',
          :is_residential   => false,
          :label            => '123 Happy Lane',
          :override         => false,
          :state            => 'CA',
          :zip              => '90007'
        }
      }
      employee.addressbook_list.should be_kind_of(NetSuite::Records::EmployeeAddressbookList)
      employee.addressbook_list.addressbooks.length.should eql(1)
    end

    it 'can be set from a EmployeeAddressbookList object' do
      employee_addressbook_list = NetSuite::Records::EmployeeAddressbookList.new
      employee.addressbook_list = employee_addressbook_list
      employee.addressbook_list.should eql(employee_addressbook_list)
    end
  end

  describe '#roles_list' do
    it 'can be set from attributes' do
      employee.roles_list = {
        :roles => {
          :selected_role    => 'Administrator'
        }
      }
      employee.roles_list.should be_kind_of(NetSuite::Records::EmployeeRolesList)
      employee.roles_list.roles.length.should eql(1)
    end

    it 'can be set from a EmployeeRolesList object' do
      employee_roles_list = NetSuite::Records::EmployeeRolesList.new
      employee.roles_list = employee_roles_list
      employee.roles_list.should eql(employee_roles_list)
    end
  end

  describe '#custom_field_list' do
    it 'can be set from attributes' do
      attributes = {
        :custom_field => {
          :value => 10,
          :internal_id => 'custfield_something'
        }
      }
      employee.custom_field_list = attributes
      employee.custom_field_list.should be_kind_of(NetSuite::Records::CustomFieldList)
      employee.custom_field_list.custom_fields.length.should eql(1)
    end

    it 'can be set from a CustomFieldList object' do
      custom_field_list = NetSuite::Records::CustomFieldList.new
      employee.custom_field_list = custom_field_list
      employee.custom_field_list.should eql(custom_field_list)
    end
  end

  describe '.get' do
    context 'when the response is successful' do
      let(:response) { NetSuite::Response.new(:success => true, :body => { :is_person => true }) }

      it 'returns a Employee instance populated with the data from the response object' do
        NetSuite::Actions::Get.should_receive(:call).with(NetSuite::Records::Employee, :external_id => 1).and_return(response)
        employee = NetSuite::Records::Employee.get(:external_id => 1)
        employee.should be_kind_of(NetSuite::Records::Employee)
        employee.is_inactive.should be_false
      end
    end

    context 'when the response is unsuccessful' do
      let(:response) { NetSuite::Response.new(:success => false, :body => {}) }

      it 'raises a RecordNotFound exception' do
        NetSuite::Actions::Get.should_receive(:call).with(NetSuite::Records::Employee, :external_id => 1).and_return(response)
        lambda {
          NetSuite::Records::Employee.get(:external_id => 1)
        }.should raise_error(NetSuite::RecordNotFound,
          /NetSuite::Records::Employee with OPTIONS=(.*) could not be found/)
      end
    end
  end

  describe '#add' do
    let(:employee) { NetSuite::Records::Employee.new(:entity_id => 'TEST EMPLOYEE', :is_person => true) }

    context 'when the response is successful' do
      let(:response) { NetSuite::Response.new(:success => true, :body => { :internal_id => '1' }) }

      it 'returns true' do
        NetSuite::Actions::Add.should_receive(:call).
            with(employee).
            and_return(response)
        employee.add.should be_true
      end
    end

    context 'when the response is unsuccessful' do
      let(:response) { NetSuite::Response.new(:success => false, :body => {}) }

      it 'returns false' do
        NetSuite::Actions::Add.should_receive(:call).
            with(employee).
            and_return(response)
        employee.add.should be_false
      end
    end
  end

  describe '#delete' do
    context 'when the response is successful' do
      let(:response) { NetSuite::Response.new(:success => true, :body => { :internal_id => '1' }) }

      it 'returns true' do
        NetSuite::Actions::Delete.should_receive(:call).
            with(employee).
            and_return(response)
        employee.delete.should be_true
      end
    end

    context 'when the response is unsuccessful' do
      let(:response) { NetSuite::Response.new(:success => false, :body => {}) }

      it 'returns false' do
        NetSuite::Actions::Delete.should_receive(:call).
            with(employee).
            and_return(response)
        employee.delete.should be_false
      end
    end
  end

  describe '#to_record' do
    let(:employee) { NetSuite::Records::Employee.new(:entity_id => 'TEST EMPLOYEE', :is_person => true) }

    it 'returns a hash of attributes that can be used in a SOAP request' do
      employee.to_record.should eql({
        'listEmp:entityId' => 'TEST EMPLOYEE'
      })
    end
  end

  describe '#record_type' do
    it 'returns a string type for the record to be used in a SOAP request' do
      employee.record_type.should eql('listEmp:Employee')
    end
  end

end
