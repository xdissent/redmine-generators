# Redmine Generators

[![Build Status](https://travis-ci.org/xdissent/redmine-generators.png?branch=master)](https://travis-ci.org/xdissent/redmine-generators)
[![Gem Version](https://badge.fury.io/rb/redmine-generators.png)](http://badge.fury.io/rb/redmine-generators)

Helpful generators for [Redmine](http://redmine.org) plugin authors.

## Crash Course

Recreate the [Redmine plugin tutorial](http://www.redmine.org/projects/redmine/wiki/Plugin_Tutorial)
using the `redmine:plugin` and `redmine:scaffold` generators:

```console
$ git clone https://github.com/redmine/redmine.git; cd redmine
$ echo "development:\n  adapter: sqlite3\n  database: db/dev.db" > config/database.yml
$ echo 'gem "redmine-generators", group: :development' >> Gemfile.local
$ bundle --without rmagick   # Or whatever
$ rails g redmine:plugin polls
$ rails g redmine:scaffold polls poll question yes:integer no:integer
$ rake generate_secret_token db:migrate redmine:plugins:migrate
$ REDMINE_LANG=en rake redmine:load_default_data
```

Add a `vote` method to the `Poll` model in `plugins/redmine_polls/app/models/poll.rb`:

```ruby
def vote(answer)
  increment(answer == "yes" ? :yes : :no)
end
```

Create a `vote` action for the `PollsController` in `plugins/redmine_polls/app/controllers/polls_controller.rb`:

```ruby
def vote
  @poll.vote params[:answer]
  flash[:notice] = "Voted #{params[:answer]}" if @poll.save && !request.xhr?
  respond_with(@poll) do |format|
    format.js { render action: :show }
  end
end
```

Create a member route in `plugins/redmine_polls/config/routes.rb` for the new
`vote` action:

```ruby
scope "/projects/:project_id" do
  resources :polls do
    post "vote", on: :member
  end
end
```

Add the `vote` method to the `respond_to :js` and `before_filter :find_poll`
statements:

```ruby
respond_to :js, only: [:show, :new, :create, :edit, :update, :destroy, :vote]
# ...
before_filter :find_poll, only: [:show, :edit, :update, :destroy, :vote]
```

Add voting links to `plugins/redmine_polls/app/views/polls/show.html.erb`:

```erb
<p>
  <b>Vote:</b>
  <%= link_to "Yes", vote_poll_path(@poll, answer: "yes"), method: :post %> |
  <%= link_to "No", vote_poll_path(@poll, answer: "no"), method: :post %>
</p>
```

And basically the same for `plugins/redmine_polls/app/views/polls/show.js.erb` 
but using `remote: true` for AJAX links:

```erb
<p>
  <b>Vote:</b>
  <%= link_to "Yes", vote_poll_path(@poll, answer: "yes"), method: :post, remote: true %> |
  <%= link_to "No", vote_poll_path(@poll, answer: "no"), method: :post, remote: true %>
</p>
```

Finally, add a `:vote_polls` Redmine permission to the `:polls` project module 
in `plugins/redmine_polls/init.rb`:

```ruby
  project_module :polls do
    # ...
    permission :vote_polls, polls: [:vote]
  end
```

Start the rails server if you haven't already with `rails s`. Grant voting 
access to whichever roles you'd like at 
[http://localhost:3000/roles/permissions](http://localhost:3000/roles/permissions),
create a project with the `:polls` module enabled, and start polling!

This project rocks and uses MIT-LICENSE.