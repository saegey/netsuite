module NetSuite
  module Records
    class Vendor
      include Support::Fields
      include Support::RecordRefs
      include Support::Records
      include Support::Actions
      include Namespaces::ListRel

      actions :get, :add, :update, :delete, :search, :search_more_with_id

      fields :entity_id, :alt_name, :is_person, :phonetic_name, :salutation,
        :first_name, :middle_name, :last_name, :company_name, :is_inactive

      field :addressbook_list,  CustomerAddressbookList
      field :custom_field_list, CustomFieldList

      # read_only_fields :balance, :consol_balance, :deposit_balance, :consol_deposit_balance, :overdue_balance,
      #   :consol_overdue_balance, :unbilled_orders, :consol_unbilled_orders

      record_refs :custom_form, :category

      attr_reader   :internal_id
      attr_accessor :external_id

      def initialize(attributes = {})
        # @internal_id = attributes.delete(:internal_id) || attributes.delete(:@internal_id)
        # @external_id = attributes.delete(:external_id) || attributes.delete(:@external_id)
        initialize_from_attributes_hash(attributes)
        @internal_id = attributes[:internal_id] || attributes[:@internal_id]
        @external_id = attributes[:external_id] || attributes[:@external_id]
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
