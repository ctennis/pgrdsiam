# pgrdsiam

_I wrote this code in 2019, it may be horribly out of date now._

This gem serves as a wrapper that handles dynamically generating an RDS password for a 
ActiveRecord Postgres database via an IAM role.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pgrdsiam'
```

Then, create a file 'config/initializers/pgrdsiam.rb', with the following lin:

```
require 'pgrdsiam/postgresql_adapter'
```

## Configuration

Edit the database.yml, remove the password config line, and add `:use_iam = true`.

## How it works

We override ActiveRecord::ConnectionHandling.postgresql_connection and intercept new
connection configs.  If use_iam is true, then we use instance profile credentials and the
current known database config to generate a temporary set of RDS IAM credentials.  We then
stuff this into the current password field, and continue on with the connection creation.

These credentials only have a lifetime of 15 minutes. The postgres connection will continue to
work, but you cannot reconnect with the same credentials after they expire. This is not an issue
in practice, Rails generally doesn't try to reconnect. However, if the connection to the database does go away for some reason (reboot, network issues, etc), Rails should attempt at some point to throw away the connection and generate a new one - which will lead to a new 
set of credentials being generated.

This should all be transparent.

By default the gem will use instance profile credentials unless AWS_ env variables are set,
in which case it will use them instead.  This can be useful for testing.

## Running Tests

```
bundle exec rake
```