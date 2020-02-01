require_dependency 'queries_helper'
require_dependency 'issue_query'
module Patches
  module TimeTaskOverrun
    module QueriesHelperPatch
      include Redmine::I18n

      def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
          alias_method :column_value, :column_value_ext
        end
      end

      #
      module InstanceMethods
        #data processing in the column spend_hours
        def column_value_ext(column, item, value)
          binding.pry
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
          when :hours, :estimated_hours

            if value.to_f > 0.01
              format_hours(value.to_f.round(2))
            end
          when :spent_hours
            if Setting.plugin_custom_improvements['improvements_disable_overrun'].to_i == 0
              if item.estimated_hours.to_f > 0 && item.spent_hours.to_f > 0
                link = project_time_entries_path(item.project, :issue_id => "~#{item.id}")
                val = (
                if (item.estimated_hours.nil? || item.spent_hours.nil?)
                  0
                else
                  rez = (item.estimated_hours - item.spent_hours) * -1
                  rez.round(3)
                end)
                link_to(format_hours(value), link) + (
                if val > 0
                  # link_to('(' + (val > 0 ? '+' : '') + "#{format_hours(val).to_f.round(3)}" + ')', link, style: (val < 0 ? 'color:#00cc00' : 'color:#cc0000'))
                  link_to(' (' + (val > 0 ? '+' : '') + "#{format_hours(val)}" + ')', link, style: 'color:#cc0000')
                end)
              elsif item.spent_hours.to_i > 0
                link = project_time_entries_path(item.project, :issue_id => "~#{item.id}")
                link_to(format_hours(item.spent_hours), link)
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