require "active_support/concern"

module Redmine
  module Generators
    module PluginNameAttribute
      extend ActiveSupport::Concern

      def initialize(args = [], options = {}, config = {})
        self.plugin_name = args.shift unless plugin_name
        plugin_destination = plugin_destination_root
        raise "Invalid plugin name #{plugin_name}" if bail_on_missing? && !plugin_destination
        super
        self.destination_root = plugin_destination
      end

      protected
      def bail_on_missing?
        true
      end

      def plugin_name=(name)
        Redmine::Generators.plugin = name
      end

      def plugin_name
        Redmine::Generators.plugin
      end

      def possible_plugin_names
        %W(#{plugin_name} redmine_#{plugin_name} chiliproject_#{plugin_name})
      end

      def plugin_destination_root
        possible_plugin_paths.find { |p| p.exist? }
      end

      def possible_plugin_paths
        possible_plugin_names.map { |p| Rails.root.join "plugins", p }
      end
    end
  end
end