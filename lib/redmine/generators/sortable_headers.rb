require "active_support/concern"

module Redmine
  module Generators
    module SortableHeaders
      extend ActiveSupport::Concern

      def sortable_header(name, caption = "field_#{name}", order = nil)
        if parent_options[:sort]
          order = ", " + key_value(:default_order, %("#{order}")) if order
          %(<%= sort_header_tag "#{name}", caption: l(:#{caption})#{order} %>)
        else
          "<th><%= l(:#{caption}) %></th>"
        end
      end
    end
  end
end