# This whole module should not be necessary, but it seems there is a bug in
# Redmine when sending notification mails if date custom fields are defined.
# This module implements a workaround.
module DueSubtaskCustomFieldsHelperPatch
  def self.included(base)
    base.send(:include, InstanceMethods)
    base.class_eval do
      unloadable
      alias_method_chain :show_value, :due_subtask
    end
  end

  module InstanceMethods
    # Return a string used to display a custom value
    def show_value_with_due_subtask(custom_value)
      return "" unless custom_value
      if custom_value.custom_field.name == "Due subtask"
        if custom_value.value.blank?
          ""
        else
          format_date(custom_value.value.to_date)
        end
      else
        show_value_without_due_subtask(custom_value)
      end
    end
  end
end
