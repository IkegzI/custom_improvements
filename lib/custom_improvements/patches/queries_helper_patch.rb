require_dependency 'queries_helper'
require_dependency 'issue_query'
module CustomImprovements
  module Patches
    module QueriesHelperPatch
      include Redmine::I18n

      def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
          alias_method :column_value, :ci_column_value_ext
        end
      end

      #
      module InstanceMethods
        #data processing in the column spend_hours
        def ci_column_value_ext(column, item, value)
          case column.name
          when :id
            link_to value, issue_path(item)
          when :subject
            link_to value, issue_path(item)
          when :parent
            value ? (value.visible? ? link_to_issue(value, :subject => false) : "##{value.id}") : ''
          when :description
            item.description? ? content_tag('div', textilizable(item, :description), :class => "wiki") : ''
          when :last_notes
            item.last_notes.present? ? content_tag('div', textilizable(item, :last_notes), :class => "wiki") : ''
          when :done_ratio
            progress_bar(value)
          when :relations
            content_tag('span',
                        value.to_s(item) { |other| link_to_issue(other, :subject => false, :tracker => false) }.html_safe,
                        :id => value.css_classes_for(item))
          when :hours
            format_hours(value)
          when :estimated_hours
            format_hours(value.round(2)) if value.to_f.round(2) > 0
          when :spent_hours
            value = value.round(2)
            if Setting.plugin_custom_improvements['improvements_disable_overrun'].to_i == 0
              if item.estimated_hours.to_f.round(2) > 0 && item.spent_hours.to_f.round(2) > 0
                link = project_time_entries_path(item.project, :issue_id => "~#{item.id}")
                val = (
                if (item.estimated_hours.nil? || item.spent_hours.nil?)
                  0
                else
                  (item.estimated_hours.round(2) - item.spent_hours.round(2)).round(2) * -1
                end)
                link_to(format_hours(value), link) + (

                if val > 0
                  link_to(' (' + (val > 0 ? '+' : '') + "#{format_hours(val.round(2))}" + ')', link, style: 'color:#cc0000')
                end)
              elsif item.spent_hours.round(2) >= 0
                link = "/projects/#{item.project.identifier}/time_entries?issue_id=~#{item.id}"
                link_to_if(item.spent_hours.round(2) > 0, format_hours(item.spent_hours.round(2)), link)
              end
            else
              link_to(format_hours(value), project_time_entries_path(item.project, :issue_id => "#{item.id}")) if value > 0
            end
          when :total_spent_hours
            link_to_if(value > 0, format_hours(value), project_time_entries_path(item.project, :issue_id => "~#{item.id}"))

          when :attachments
            value.to_a.map { |a| format_object(a) }.join(" ").html_safe
          else
            format_object(value)
          end
        end

      end
    end
  end
end