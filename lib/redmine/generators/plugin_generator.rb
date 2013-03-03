require "redmine/generators/plugin_name_attribute"
require "rails/generators/named_base"

module Redmine
  module Generators
    class PluginGenerator < Rails::Generators::NamedBase

      def create_root
        empty_directory '.'
      end

      def init_rb
        template "init.rb"
      end

      def config
        empty_directory "config"
      end

      def routes
        template "routes.rb", "config/routes.rb"
      end

      def locales
        empty_directory "config/locales"
      end

      def translations
        template "en.yml", "config/locales/en.yml"
      end

      def plugin_lib
        empty_directory "lib"
        empty_directory "lib/#{name}"
        template "plugin.rb", "lib/#{name}.rb"
        template "version.rb", "lib/#{name}/version.rb"
      end

      def app_folders
        empty_directory "app"
        empty_directory_with_gitkeep "app/models"
        empty_directory_with_gitkeep "app/controllers"
        empty_directory_with_gitkeep "app/helpers"
        empty_directory_with_gitkeep "app/views"
      end

      def gemfile
        template "Gemfile"
      end

      def initialize(args = [], options = {}, config = {})
        args[0] = ideal_plugin_name(args[0]) if config[:behavior] == :invoke
        super args, options, config
        if ideal_plugin_path.exist? && behavior == :invoke
          raise "Plugin #{name} already exists." 
        end
        self.destination_root = ideal_plugin_path
      end

      protected
      def ideal_plugin_name(pname = name)
        "redmine_" + pname.gsub(/^(redmine|chiliproject)_/, "")
      end

      def ideal_plugin_path
        Rails.root.join "plugins", ideal_plugin_name
      end

      def redmine_version
        require "redmine/version"
        "#{Redmine::VERSION::MAJOR}.#{Redmine::VERSION::MINOR}.#{Redmine::VERSION::TINY}"
      end

      def user_name
        `git config --global --get user.name`.strip
      end

      def empty_directory_with_gitkeep(destination, config = {})
        empty_directory(destination, config)
        git_keep(destination)
      end

      def git_keep(destination)
        create_file("#{destination}/.gitkeep")
      end
    end
  end
end