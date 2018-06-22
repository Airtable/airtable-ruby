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

Also you can have `AIRTABLE_KEY` environment variable which is your API key.

```ruby
# if you have AIRTABLE_KEY variable
@client = Airtable::Client.new
```

Your API key carries the same privileges as your user account, so be sure to keep it secret!

### Accessing a Base

Now we can access any base in our Airtable account by referencing the [API docs](https://airtable.com/api):

```ruby
# Pass in the base id
@base = @client.table("appPo84QuCy2BPgLk")
```

### Accessing a Table

Now we can access any table in our Airtable account by referencing the [API docs](https://airtable.com/api):

```ruby
# Pass in the table name
@table = @base.table("Table Name")
```

### Batch Querying All Records

Once you have access to a table from above, we can query a set of records in the table with:

```ruby
@records = @table.select
```

We can specify a `sort` order, `per_page`, `max_records` and `offset` as part of our query:

```ruby
@records = @table.records(:sort => ["Name", :asc], :page_size => 50)
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

This executes a variable number of network requests (100 records per batch) to retrieve all records in a sheet.

We can also use  `select` method to query based on specific conditions using `formula` parameter

```ruby
@records = @table.select(sort: ["Order", "asc"], formula: "Active = 1")
```

This will return all the records that has `Active` column value as `true` from table.


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

## Command Line Tool

This gem includes a simple command line tool which shows the basic functionality of the service.

```
$ airtable
Usage: airtable operation options

Common options:
    -k, --api_key=KEY                Airtable API key
    -t, --table NAME                 Table Name
    -b, --base BASE_ID               Base ID
    -r, --record RECORD_ID           Record ID
    -f, --field FIELD_NAME           Field name to update or read
    -v, --value VALUE                Field value for update

Supported Operations:
	get - Get Record/Field
	update - Update Field

Examples:
	airtable get -B Base -t Table
	airtable get -B Base -t Table -r RECORD_ID
	airtable get -B Base -t Table -f FIELD_NAME
	airtable get -B Base -t Table -f FIELD_NAME -r RECORD_ID
	airtable update -b Base -t table -r RECORD_ID -f FIELD_NAME -v newValue

    -h, --help                       Show this message
        --version                    Show version
```

### Get record's JSON

```
$ airtable get -b base_id -t Table -r record_id
{"id":"record_id","fields":{...},"createdTime":"2015-11-11 23:05:58 UTC"}
```

### Get record's field value

```
$ airtable get -b base_id -t Table -r record_id -f field_name
FIELD_VALUE
```

### Update record's field value

```
$ airtable update -b base_id -t Table -r record_id -f field_name -v NEW_VALUE
OK
```

## Contributing

1. Fork it ( https://github.com/nesquena/airtable-ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
