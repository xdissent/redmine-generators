require "<%= name %>"
require "<%= name %>/version"

Redmine::Plugin.register :<%= name %> do
  name "<%= name.titleize %>"
  author "<%= user_name %>"
  description "<%= name.titleize %>"
  version <%= class_name %>::VERSION
  url ""
  author_url ""
  requires_redmine version_or_higher: "<%= redmine_version %>"
  settings partial: "<%= name %>", default: {}
end