require "active_support/concern"

module Redmine
  module Generators
    module PluginSupport
      extend ActiveSupport::Concern

      included do
        templates_path << File.expand_path("../templates", __FILE__)
        
        class << self
          def lookup_with_redmine(namespaces)
            redmine_names = namespaces.select { |ns| ns.start_with? "redmine:" }
            redmine_names.each do |ns|
              require "redmine/generators/#{ns.split(":").last}_generator"
            end
            lookup_without_redmine (namespaces - redmine_names)
          end
          alias_method_chain :lookup, :redmine

          def lookup_with_redmine!
            Dir[File.expand_path("../*_generator.rb", __FILE__)].each do |path|
              require File.join("redmine/generators", File.basename(path, ".rb"))
            end
            lookup_without_redmine!
          end
          alias_method_chain :lookup!, :redmine
        end
      end
    end
  end
end