module NetSuite
  module Records
    class EmployeeAddressbook
      include Support::Fields
      include Support::Records
      include Support::Actions
      include Namespaces::ListEmp

      actions :get, :add, :delete, :update

      fields :default_shipping, :default_billing, :label, :attention, :addressee,
        :phone, :addr1, :addr2, :addr3, :city, :state, :zip, :country, :addr_text, :override

      attr_reader   :internal_id
      attr_accessor :external_id

      def initialize(attributes_or_record = {})
        case attributes_or_record
        when self.class
          initialize_from_record(attributes_or_record)
        when Hash
          attributes_or_record = attributes_or_record[:addressbook] if attributes_or_record[:addressbook]
          @internal_id = attributes_or_record.delete(:internal_id)
          initialize_from_attributes_hash(attributes_or_record)
        end
      end

      def initialize_from_record(obj)
        self.default_shipping = obj.default_shipping
        self.default_billing  = obj.default_billing
        self.label            = obj.label
        self.attention        = obj.attention
        self.addressee        = obj.addressee
        self.phone            = obj.phone
        self.addr1            = obj.addr1
        self.addr2            = obj.addr2
        self.addr3            = obj.addr3
        self.city             = obj.city
        self.state            = obj.state
        self.zip              = obj.zip
        self.country          = obj.country
        self.addr_text        = obj.addr_text
        self.override         = obj.override
        @internal_id          = obj.internal_id
      end

    end
  end
end
