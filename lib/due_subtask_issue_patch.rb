require_dependency 'issue'

module DueSubtaskIssuePatch
  def self.included(base)
    base.send(:include, InstanceMethods)
    base.class_eval do
      unloadable

      alias_method_chain :safe_attributes=, :due_subtask
      alias_method_chain :read_only_attribute_names, :due_subtask
      alias_method_chain :recalculate_attributes_for, :due_subtask

      # Use after_create and after_update as a way to prepend this callback to
      # the after_save ones
      after_create :update_due_subtask
      after_update :update_due_subtask
    end
  end

  module InstanceMethods
    def safe_attributes_with_due_subtask=(attrs, user=User.current)
      if attr_id = IssueCustomField.where(:name => "Due subtask").pluck(:id).first
        if attrs['custom_field_values'] && attrs['custom_field_values'].kind_of?(Hash)
          attrs['custom_field_values'].delete(attr_id.to_s)
        end
      end
      send :safe_attributes_without_due_subtask=, attrs, user
    end

    def read_only_attribute_names_with_due_subtask(user=nil)
      attrs = read_only_attribute_names_without_due_subtask(user)
      if attr_id = IssueCustomField.where(:name => "Due subtask").pluck(:id).first
        attrs + [attr_id.to_s]
      else
        attrs
      end
    end
    
    def recalculate_attributes_for_with_due_subtask(issue_id)
      if issue_id && p = Issue.find_by_id(issue_id)
        if field = p.available_custom_fields.detect {|i| i.name == 'Due subtask'}
          # min = The minimum "due_subtask" from all the open children
          # TODO: implementing this in ruby code is not the most efficient approach
          min = p.children.open.map {|i| i.custom_field_values.detect{|v| v.custom_field == field}}.compact.map {|v| v.value}.compact.min
          p.custom_field_values = {field.id => min }
          p.save_custom_field_values
        end
      end
      recalculate_attributes_for_without_due_subtask(issue_id)
    end

    def update_due_subtask
      if leaf? && field = available_custom_fields.detect {|i| i.name == 'Due subtask'}
        self.custom_field_values = {field.id => due_date }
        save_custom_field_values
      end
      true
    end
  end
end
