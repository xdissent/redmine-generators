<% if namespaced? -%>
require_dependency "<%= namespaced_file_path %>/application_controller"

<% end -%>
<% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationController
  unloadable
  
  respond_to :html, :json
<% if options[:remote] -%>
  respond_to :js, only: [:show, :new, :create, :edit, :update, :destroy]
<% end -%>

<% if options[:project] -%>
  before_filter :find_project_by_project_id
<% end -%>
  before_filter :find_<%= singular_table_name %>, only: [:show, :edit, :update, :destroy]
<% if options[:authorize] -%>
  before_filter :authorize
<% end -%>
<% if options[:sort] -%>

  include SortHelper
  helper :sort
<% end -%>

  def index
<% if options[:sort] -%>
    <%= sort_initializer %>
<% end -%>
<% if options[:project] -%>
    <%= "@#{singular_table_name}_pages, " if options[:pagination] %>@<%= plural_table_name %> = <%= "paginate " if options[:pagination] %><%= "#{class_name}.where(project_id: @project)" %><%= ".order(sort_clause)" if options[:sort] %>
<% else -%>
    <%= "@#{singular_table_name}_pages, " if options[:pagination] %>@<%= plural_table_name %> = <%= "paginate " if options[:pagination] %><%= orm_class.all(class_name) %><%= ".order(sort_clause)" if options[:sort] %>
<% end -%>
    respond_with @<%= plural_table_name %>
  end

  def show
    respond_with @<%= singular_table_name %>
  end

  def new
    @<%= singular_table_name %> = <%= orm_class.build(class_name) %>
    respond_with @<%= singular_table_name %>
  end

  def edit
    respond_with @<%= singular_table_name %>
  end

  def create
    @<%= singular_table_name %> = <%= orm_class.build(class_name, "params[:#{singular_table_name}]") %>
<% if options[:project] -%>
    @<%= singular_table_name %>.project = @project
<% end -%>
<% if options[:author] -%>
    @<%= singular_table_name %>.author = User.current
<% end -%>
    if @<%= singular_table_name %>.save && !request.xhr?
      flash[:notice] = l(:label_<%= singular_table_name %>_created)
    end
    respond_with @<%= singular_table_name %>
  end

  def update
    if @<%= orm_instance.update_attributes("params[:#{singular_table_name}]") %> && !request.xhr?
      flash[:notice] = l(:label_<%= singular_table_name %>_updated)
    end
    respond_with @<%= singular_table_name %>
  end

  def destroy
    @<%= orm_instance.destroy %>
    flash[:notice] = l(:label_<%= singular_table_name %>_deleted) unless request.xhr?
    respond_with @<%= singular_table_name %>, location: <%= index_helper %>_path
  end

<% if options[:project] -%>
  # Override url/path convenience methods options to include project
  def url_options
    super.reverse_merge project_id: @project
  end
<% end -%>

  private
  def find_<%= singular_table_name %>
    @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
<% if options[:project] -%>
    render_404 unless @<%= singular_table_name %>.project_id == @project.id
<% end -%>
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end
<% end -%>
