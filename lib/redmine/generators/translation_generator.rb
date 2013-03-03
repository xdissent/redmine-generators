require "redmine/generators/plugin_name_attribute"
Rails::Generators.lookup %w(rails:model)

module Redmine
  module Generators
    class TranslationGenerator < Rails::Generators::ModelGenerator
      include PluginNameAttribute

      class_option :lang, type: :string, default: "en", desc: "The language for translations"
      
      remove_hook_for :orm

      def add_translations
        translation "label_#{singular_table_name}", human_name
        translation "label_#{singular_table_name}_plural", plural_name.capitalize
        translation "label_#{singular_table_name}_new", "New #{human_name}"
        translation "label_#{singular_table_name}_edit", "Edit #{human_name}"
        translation "label_#{singular_table_name}_created", "#{human_name} was successfully created."
        translation "label_#{singular_table_name}_updated", "#{human_name} was successfully updated."
        translation "label_#{singular_table_name}_destroyed", "#{human_name} was successfully deleted."

        attributes.each do |attribute|
          translation "field_#{attribute.name}", attribute.human_name
        end
      end

      private
      def translation(key, value, lang = options[:lang])
        log :translation, "#{lang}: #{key}"

        locale_path = "config/locales/#{lang}.yml"
        trans = "  #{key}: \"#{value}\"\n"
        sentinel = "#{lang}:\n"

        in_root do
          inject_into_file locale_path, trans, after: sentinel, verbose: false
        end
      end
    end
  end
end