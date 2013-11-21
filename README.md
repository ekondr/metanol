# Metanol

This is a meta tags plugin which helps to manage meta tags in your Rails application. It supports some OpenGraph meta tags, Webmaster's meta tags (such as Google, Bing, Yandex, Alexa verification meta tags) and other standard HTML meta tags (such as a description). It can be used by Rails 3.2+ applications.

## Installation

Add this line to your application's Gemfile:

    gem 'metanol'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install metanol

## Usage

There are two ways to set meta tags. The first one is a setting values for meta tags in a controller:
    
```ruby
class HomeController < ApplicationController
  og_meta :type,    'website'
  og_meta :locale,  'uk_UA'

  wm_meta :alexa,   'alexa code'
  wm_meta :bing,    'bing code'
  wm_meta :google,  'google code'
  wm_meta :yandex,  'yandex code'

  def new
    render :inline => <<-ERB
      <%= metanol_wm_tags %>
    ERB
  end
end
```

The second one is a setting values for meta tags in a controller's action:  

```ruby
class TestsController < ApplicationController
  def index
    meta :title, "Users List"
    meta :description, "Description for a users list"
    og_meta title: "OpenGraph Title", description: "OpenGraph Description"
    render :inline => <<-ERB
      <%= metanol_main_tags %>
    ERB
  end
end
```

There are three methods for setting values for meta tags:
* `meta(meta_name, value) or meta({meta_name: value, meta_name2: value2, ...})` - sets a value(s) for common meta tags
* `og_meta` - sets a value(s) for OpenGraph's meta tags
* `wm_meta` - sets a value(s) for Webmaster verification's meta tags

This plugin also gives you the ability to set the TITLE tag: `meta :title, "Page title"` renders into `<title>Page title</title>`.

There are some filters which you can set for methods above:
* `html` - to get rid of HTML tags in a value (i.e. `meta :title, "Page title", :html`)
* `overspaces` - to get rid of too many spaces, leave only one space between words
* `whitespaces` - to get rid of whitespaces in a value (i.e. `meta({title: "Page title", description: 'Page description'}, :html, :whitespaces)`)
* `clean` - apply `html`, `overspaces` and `whitespaces` filters for a value

Here is the helper's methods for rendering meta tags:
* `metanol_tags` - renders all meta tags (Webmaster, OpenGraph and other)
* `metanol_og_tags` - renders only OpenGraph's meta tags
* `metanol_wm_tags` - renders Webmaster verification tags
* `metanol_main_tags` - renders other meta tags, such as keywords, description, etc.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
