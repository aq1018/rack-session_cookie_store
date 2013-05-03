# Rack::Session::CookieStore

Node.js connect compatible signed cookie session store.
Use this gem if you want to share cookie sessions between your rack / rails
app with connect / express framework from Node.js

## Installation

Add this line to your application's Gemfile:

    gem 'rack-session-cookie_store'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack-session-cookie_store

## Usage

```ruby
# In Rack
use Rack::Session::CookieStore, secret: 'your secret',
                                domain: 'your.domain.com',
                                key:    'your.session.key'
```

```coffeescript
# In Node

connect = require 'connect'
app     = connect()

app.use connect.cookieParser()

app.use connect.cookieSession(
  secret: 'your secret'
  key:    'your.session.key'
  cookie:
    domain: 'your.domain.com'
)
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
