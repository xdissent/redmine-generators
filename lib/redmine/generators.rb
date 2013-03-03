require "rails/generators"
require "redmine/generators/plugin_support"

module Redmine
  module Generators
    class << self
      attr_accessor :plugin
    end

    Rails::Generators.send :include, PluginSupport
  end
end