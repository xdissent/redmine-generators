require "redmine/generators/plugin_name_attribute"
Rails::Generators.lookup %w(rails:resource_route)

module Redmine
  module Generators
    class ResourceRouteGenerator < Rails::Generators::ResourceRouteGenerator
      include PluginNameAttribute

      class_option :project, type: :boolean, default: true, desc: "Add project model relation"

      private
      def route(*args)
        return super unless options[:project]
        indented = route_string.split("\n").map { |l| "  #{l}" }.compact.join "\n"
        super %(scope "/projects/:project_id" do\n#{indented}\n  end)
      end
    end
  end
end