# Airtable Ruby Client

Easily connect to [airtable](https://airtable.com) data using ruby with access to all of the airtable features.

# Note on library status

We are currently transitioning this gem to be supported by
Airtable. We will maintain it moving forward, but until we fully
support it, it will stay in the status of "community libraries". At
that time we will remove this notice and add a "ruby" section to the
API docs.

## Installation

Add this line to your application's Gemfile:

    gem 'airtable'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install airtable

## Usage

### Creating a Client

First, be sure to register for an [airtable](https://airtable.com) account, create a data worksheet and [get an api key](https://airtable.com/account). Now, setup your Airtable client:

```ruby
# Pass in api key to client
@client = Airtable::Client.new("keyPCx5W")
```

Your API key carries the same privileges as your user account, so be sure to keep it secret!

### Accessing a Table

Now we can access any table in our Airsheet account by referencing the [API docs](https://airtable.com/api):

```ruby
# Pass in the app key and table name
@table = @client.table("appPo84QuCy2BPgLk", "Table Name")
```

### Querying Records

Once you have access to a table from above, we can query a set of records in the table with:

```ruby
@records = @table.records
```

We can specify a `sort` order, `limit`, and `offset` as part of our query:

```ruby
@records = @table.records(:sort => ["Name", :asc], :limit => 50)
@records # => [#<Airtable::Record :name=>"Bill Lowry", :email=>"billery@gmail.com">, ...]
@records.offset #=> "itrEN2TCbrcSN2BMs"
```

This will return the records based on the query as well as an `offset` for the next round of records. We can then access the contents of any record:

```ruby
@bill = @record.first
# => #<Airtable::Record :name=>"Bill Lowry", :email=>"billery@gmail.com", :id=>"rec02sKGVIzU65eV1">
@bill[:id] # => "rec02sKGVIzU65eV2"
@bill[:name] # => "Bill Lowry"
@bill[:email] # => "billery@gmail.com"
```

Note that you can only request a maximimum of 100 records in a single query. To retrieve more records, use the "batch" feature below.

### Batch Querying All Records

We can also query all records in the table through a series of batch requests with:

```ruby
@records = @table.all(:sort => ["Name", :asc])
```

This executes a variable number of network requests (100 records per batch) to retrieve all records in a sheet.

### Finding a Record

Records can be queried by `id` using the `find` method on a table:

```ruby
@record = @table.find("rec02sKGVIzU65eV2")
# => #<Airtable::Record :name=>"Bill Lowry", :email=>"billery@gmail.com", :id=>"rec02sKGVIzU65eV1">
```

### Inserting Records

Records can be inserted using the `create` method on a table:

```ruby
@record = Airtable::Record.new(:name => "Sarah Jaine", :email => "sarah@jaine.com")
@table.create(@record)
# => #<Airtable::Record :name=>"Sarah Jaine", :email=>"sarah@jaine.com", :id=>"rec03sKOVIzU65eV4">
```

### Updating Records

Records can be updated using the `update` method on a table:

```ruby
@record[:email] = "sarahjaine@updated.com"
@table.update(record)
# => #<Airtable::Record :name=>"Sarah Jaine", :email=>"sarahjaine@updated.com", :id=>"rec03sKOVIzU65eV4">
```

### Deleting Records

Records can be destroyed using the `destroy` method on a table:

```ruby
@table.destroy(record)
```

## Contributing

1. Fork it ( https://github.com/nesquena/airtable-ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
