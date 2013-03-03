require "active_support/concern"

module Redmine
  module Generators
    module RemoteableLinks
      extend ActiveSupport::Concern

      protected
      def maybe_remote
        ", " + key_value(:remote, "true") if remote_option
      end

      def remote_option
        parent_options[:remote]
      end
    end
  end
end