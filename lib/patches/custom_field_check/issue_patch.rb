require_dependency 'issue'
module CustomFieldCheck
  module Patches
    module CustomFieldsPatch

      include Redmine::I18n

      def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
          alias_method :validate_custom_field_values, :validate_custom_field_values_ext
        end
      end

      # improvements_disable_custom_fields_check: 0
      # improvements_disable_id_custom_fields_check: 0
      module InstanceMethods


        def validate_custom_field_values_ext

          def check_error_field(arg, setting)
            if CustomImprovements.load_settings[setting] == 0
              if arg.custom_field.id == CustomImprovements.load_settings[:improvements_disable_id_custom_fields_check]
                return true if estimated_hours.nil? or estimated_hours.to_i <= 0
              end
              false
            end
          end

          user = new_record? ? author : current_journal.try(:user)
          a = editable_custom_field_values(user).each(&:validate_value)
          if new_record? || custom_field_values_changed?

            if CustomImprovements.load_settings[:improvements_disable_custom_fields_check] == 0
              a.each do |item|
                errors.add :base, :error_estimate if check_error_field(item, :improvements_disable_custom_fields_check)
              end
            end
            editable_custom_field_values(user).each(&:validate_value)
          end
        end

      end
    end
  end
end


# def validate_custom_field_values
#   user = new_record? ? author : current_journal.try(:user)
#   if new_record? || custom_field_values_changed?
#     editable_custom_field_values(user).each(&:validate_value)
#   end
# end