require "redmine/generators/plugin_name_attribute"
Rails::Generators.lookup %w(rails:model)

module Redmine
  module Generators
    class ProjectModuleGenerator < Rails::Generators::ModelGenerator
      include PluginNameAttribute
      
      remove_hook_for :orm

      def add_project_module
        pm = "  project_module :#{plural_table_name} do\n"
        pm << "    permission :view_#{plural_table_name}, #{plural_table_name}: [:index, :show]\n"
        pm << "    permission :manage_#{plural_table_name}, #{plural_table_name}: [:new, :create, :edit, :update, :destroy]\n"
        pm << "  end\n"

        sentinel = /Redmine::Plugin\.register\s+:\w+\s+do\s?\n/

        in_root do
          inject_into_file "init.rb", pm, after: sentinel
        end
      end
    end
  end
end