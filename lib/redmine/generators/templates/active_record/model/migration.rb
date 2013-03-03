class <%= migration_class_name %> < ActiveRecord::Migration
  def change
    create_table :<%= table_name %> do |t|
<% attributes.each do |attribute| -%>
      t.<%= attribute.type %> :<%= attribute.name %><%= attribute.inject_options %>
<% end -%>
<% if parent_options[:author] -%>
      t.integer :author_id, <%= key_value :default, "0" %>, <%= key_value :null, "false" %>
<% end -%>
<% if parent_options[:project] -%>
      t.integer :project_id, <%= key_value :default, "0" %>, <%= key_value :null, "false" %>
<% end -%>
<% if options[:timestamps] %>
      t.timestamps
<% end -%>
    end
<% attributes_with_index.each do |attribute| -%>
    add_index :<%= table_name %>, :<%= attribute.index_name %><%= attribute.inject_index_options %>
<% end -%>
<% if parent_options[:author] -%>
    add_index :<%= table_name %>, :author_id
<% end -%>
<% if parent_options[:project] -%>
    add_index :<%= table_name %>, :project_id
<% end -%>
  end
end
