# Refinery CMS Products

Products engine for [Refinery CMS](http://refinerycms.com) allows you to display translated products.

### In summary you can:
* Manage products (with images, file, properties)
* Manage product properties (with custom value)
* Manage product categories (with images and promote option)

### Steps before version 1.0 ###
* Add nested categorization for products (Work in Progress, help appreciated)
* Rename this engine for refinerycms-catalog

## Requirements

This version of `refinerycms-products` supports Refinery 3.x and Rails 4.1.x.

* [Refinery CMS](http://refinerycms.com) version 3.0.0 or above.
* [refinerycms-page-images](https://github.com/refinery/refinerycms-page-images) version 3.0.0 or above.

## Install

Open up your ``Gemfile`` and add at the bottom this line:

```ruby
gem 'refinerycms-products', git: 'https://github.com/bisscomm/refinerycms-products', branch: 'master'
```

Now, run ``bundle install``

Next, to install the products plugin run:

    rails generate refinery:products

Run database migrations:

    rake db:migrate

Finally seed your database and you're done.

    rake db:seed

## Usage

Enable page images for this engine in your initializer file

```
# config/initializers/refinery/page_images.rb
  config.enable_for = [
    {:model=>"Refinery::Page", :tab=>"Refinery::Pages::Tab"},
    {:model=>"Refinery::Blog::Post", :tab=>"Refinery::Blog::Tab"},
    {:model=>"Refinery::Products::Product", :tab=>"Refinery::Products::Tab"}
  ]
```

## Developing & Contributing

The version of Refinery to develop this engine against is defined in the gemspec. To override the version of refinery to develop against, edit the project Gemfile to point to a local path containing a clone of refinerycms.

### Testing

Generate the dummy application to test against

    $ bundle exec rake refinery:testing:dummy_app

Run the test suite with [Guard](https://github.com/guard/guard)

    $ bundle exec guard start

Or just with rake spec

    $ bundle exec rake spec


## More Information
* Check out our [Website](http://refinerycms.com/)
* Documentation is available in the [guides](http://refinerycms.com/guides)
* Questions can be asked on our [Google Group](http://group.refinerycms.org)
* Questions can also be asked in our IRC room, [#refinerycms on freenode](irc://irc.freenode.net/refinerycms)
