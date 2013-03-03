require "redmine/generators/plugin_name_attribute"
Rails::Generators.lookup %w(rails:model)

module Redmine
  module Generators
    class ProjectMenuGenerator < Rails::Generators::ModelGenerator
      include PluginNameAttribute
      
      remove_hook_for :orm

      def add_project_menu
        menu = %(  menu :project_menu, :#{plural_table_name}, {controller: "#{plural_table_name}", action: "index" }, caption: :label_#{singular_table_name}_plural, param: :project_id\n)
        sentinel = /Redmine::Plugin\.register\s+:\w+\s+do\s?\n/

        in_root do
          inject_into_file "init.rb", menu, after: sentinel
        end
      end
    end
  end
end