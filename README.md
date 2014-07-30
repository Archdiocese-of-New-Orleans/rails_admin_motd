rails_admin_motd
=========

A message of the day widget for rails_admin that uses [Pusher] for real time messaging.

Add to your Gemfile then bundle install:
```ruby
gem 'rails_admin_motd', github: 'Archdiocese-of-New-Orleans/rails_admin_motd'
```

Install the config. file with:
```ruby
rails g rails_admin_motd:install
```

Generate a pusher app and add the goodies to:
```ruby
config/initializers/rails_admin_motd.rb
```

Add 'motd' to your config/initializers/rails_admin.rb config.actions.  E.g.
```ruby
config.actions do
    motd
    dashboard
    index
    ...
```

Todo:
----
Testing.

[Pusher]:http://pusher.com/