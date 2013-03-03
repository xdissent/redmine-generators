<% module_namespacing do -%>
class <%= class_name %> < <%= parent_class_name.classify %>
  unloadable

<% attributes.select {|attr| attr.reference? }.each do |attribute| -%>
  belongs_to :<%= attribute.name %>
<% end -%>
<% if parent_options[:author] -%>
  belongs_to :author, <%= key_value :class_name, '"User"' %>, <%= key_value :foreign_key, '"author_id"' %>
<% end -%>
<% if parent_options[:project] -%>
  belongs_to :project
<% end -%>
<% if !accessible_attributes.empty? -%>
  attr_accessible <%= accessible_attributes.map {|a| ":#{a.name}" }.sort.join(', ') %>
<% else -%>
  # attr_accessible :title, :body
<% end -%>
<% if parent_options[:project] || parent_options[:author] -%>

  validates <%= [(":project" if parent_options[:project]), (":author" if parent_options[:author])].compact.join ", " %>, <%= key_value :presence, "true" %>

<% end -%>
end
<% end -%>
