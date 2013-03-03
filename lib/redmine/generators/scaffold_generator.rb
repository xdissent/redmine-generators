require "redmine/generators/plugin_name_attribute"
require "redmine/generators/remoteable_links"
Rails::Generators.lookup %w(rails:scaffold)

module Redmine
  module Generators
    class ScaffoldGenerator < Rails::Generators::ScaffoldGenerator
      include PluginNameAttribute
      include RemoteableLinks

      class_option :author, type: :boolean, default: true, desc: "Add author User relation"
      class_option :project, type: :boolean, default: true, desc: "Add project model relation"
      class_option :project_module, type: :boolean, default: true, desc: "Add a project module"
      class_option :project_menu, type: :boolean, default: true, desc: "Add a project menu"
      class_option :authorize, type: :boolean, default: true, desc: "Add permissions"
      class_option :pagination, type: :boolean, default: true, desc: "Add pagination"
      class_option :sort, type: :boolean, default: true, desc: "Add sorting"
      class_option :translation, type: :boolean, default: true, desc: "Add translations"
      class_option :remote, type: :boolean, default: true, desc: "User javascript ajax views"

      remove_hook_for :assets
      remove_hook_for :stylesheet_engine

      hook_for :scaffold_controller, required: true
      
      hook_for :resource_route, required: true
      hook_for :translation, required: true

      hook_for :project_module, required: true
      hook_for :project_menu, required: true

      def add_js_views
        template "_model.html.erb", "app/views/#{plural_table_name}/_#{singular_table_name}.html.erb"
        return false unless options[:remote]
        %w(_form show new create edit update destroy).each do |view|
          view_file = "#{view}.js.erb"
          template view_file, "app/views/#{plural_table_name}/#{view_file}"
        end
      end

      protected
      def remote_option
        options[:remote]
      end

      def created_by
        options[:author] ? "#{singular_table_name}.author" : "User.anonymous"
      end
    end
  end
end