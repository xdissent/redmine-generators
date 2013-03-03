require "redmine/generators/plugin_name_attribute"
require "redmine/generators/sortable_headers"
require "redmine/generators/remoteable_links"
require "rails/generators/erb/scaffold/scaffold_generator"
Rails::Generators.lookup %w(rails:scaffold_controller)

module Redmine
  module Generators
    class ScaffoldControllerGenerator < Rails::Generators::ScaffoldControllerGenerator
      include PluginNameAttribute

      argument :attributes, type: :array, default: [], banner: "field[:type][:index] field[:type][:index]"

      class_option :author, type: :boolean, default: true, desc: "Add author User relation"
      class_option :project, type: :boolean, default: true, desc: "Add project model relation"
      class_option :authorize, type: :boolean, default: true, desc: "Add permissions"
      class_option :pagination, type: :boolean, default: true, desc: "Add pagination"
      class_option :sort, type: :boolean, default: true, desc: "Add sorting"
      class_option :remote, type: :boolean, default: true, desc: "User javascript ajax views"

      def initialize(*args)
        super
        Erb::Generators::ScaffoldGenerator.send :include, SortableHeaders
        Erb::Generators::ScaffoldGenerator.send :include, RemoteableLinks
      end

      def self.base_name
        "rails"
      end

      protected
      def sort_initializer
        unsortable = [:text, :references, :belongs_to]
        sort_fields = attributes.map { |a| a.name unless unsortable.include? a.type }.compact
        "sort_init \"updated_at\"\n    sort_update %w(#{sort_fields.join " "} created_at updated_at)"
      end
    end
  end
end