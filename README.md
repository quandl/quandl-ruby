# Quandl Ruby Client

*Copyright Quandl 2015*

The official gem for all your data needs! The Quandl client can be used to interact with the latest version of the [Quandl restful API](https://www.quandl.com/tools/api). Currently V3.

Note that v1 and v2 of the REST API are deprecated and we will be moving over all functionality to V3. During this transitionary period you can continue to use the old client here: https://rubygems.org/gems/quandl_client


## Installation

```ruby
gem 'quandl'
```

## Configuration

| Option | Explanation | Example |
|---|---|---|
| api_key | Your access key | `tEsTkEy123456789` | Used to identify who you are and provide more access. |
| api_version | The version you wish to access the api with | 2015-04-09 | Can be used to test your code against the latest version without committing to it. |

```ruby
require 'quandl'
Quandl::ApiConfig.api_key = 'tEsTkEy123456789'
Quandl::ApiConfig.api_version = '2015-04-09'
```

## Retrieving Data

### Database

To retrieve a database simply use its code with the get parameter:

```ruby
require 'quandl'
Quandl::Database.get('WIKI')
=> ... wiki database ...
```

You can also retrieve a list of databases by using: 

```ruby
require 'quandl'
Quandl::Database.all
=> ... results ...
```

You can also search for specific databases by passing a query parameter such as:

```ruby
require 'quandl'
Quandl::Database.all(params: { query: 'oil' })
=> ... oil results ...
```

### Dataset

Retrieving dataset data can be done in a similar way to Databases. For example to retrieve a dataset use its full code: 

```ruby
require 'quandl'
Quandl::Dataset.get('WIKI/AAPL')
=> ... dataset ...
```

You can also retrieve the dataset through the database by using the helper method.


```ruby
require 'quandl'
Quandl::Database.get('WIKI').datasets
=> ... datasets results ...
```

or to search for datasets with `AAPL` in them use:

```ruby
require 'quandl'
Quandl::Database.get('WIKI').datasets(params: { query: 'apple' })
=> ... datasets results for apple ...
```

### Data

Dataset data can be queried through a dataset. For example:

```ruby
require 'quandl'
Quandl::Dataset.get('WIKI/AAPL').data
=> ... data ...
```

you can access the data much like you would other lists. In addition all the data column fields are mapped to their column_names for convenience:

```ruby
require 'quandl'
Quandl::Dataset.get('WIKI/AAPL').data.first.date
=> ... date ...
```

## Working with results

### Instance

All data once retrieved is abstracted into custom classes. You can get a list of the fields in each class by using the `data_fields` method.

```ruby
require 'quandl'
database = Quandl::Database.get('WIKI')
database.data_fields
=> ["id", "name", "database_code", "description", "datasets_count", "downloads", "premium", "image"]
```

You can then uses these methods in your code. Additionally you can access the data by using the hash equalivalent lookup.

```ruby
require 'quandl'
database = Quandl::Database.get('WIKI')
database.database_code
=> 'WIKI'
database['database_code']
=> 'WIKI'
```

In some cases name of the fields returned by the API may not be compatible with the ruby language syntax. These will be converted into compatible field names.

```ruby
require 'quandl'
data = Quandl::Dataset.get('WIKI/AAPL').data(params: { limit: 1 }).first
data.column_names
=> ["Date", "Open", "High", "Low", "Close", "Volume", "Ex-Dividend", "Split Ratio", "Adj. Open", "Adj. High", "Adj. Low", "Adj. Close", "Adj. Volume"]
data.data_fields
=> ["date", "open", "high", "low", "close", "volume", "ex_dividend", "split_ratio", "adj_open", "adj_high", "adj_low", "adj_close", "adj_volume"]
```

### List

Most list queries will return a paginated list of results. You can check whether the resulting list has more data by using the `more_results?` method. Depending on its results you can pass additional params to filter the data:

```ruby
require 'quandl'
databases = Quandl::Database.all
=> ... results ...
databases.more_results?
=> true
Quandl::Database.all(params: { page: 2 })
=> ... more results ...
```

Lists also function as arrays and can be iterated through. Note however that using these features will only work on the current page of data you have locally. You will need to continue to fetch results and iterate again to loop through the full result set.

```ruby
require 'quandl'
databases = Quandl::Database.all.each { |d| puts d.database_code }
=> ... print database codes ...
databases.more_results?
=> true
Quandl::Database.all(params: { page: 2 }).each { |d| puts d.database_code }
=> ... print more database codes ...
```

Lists also return metadata associated with the request. This can include things like the current page, total results, etc. Each of these fields can be accessed through a hash or convenience method.

```ruby
require 'quandl'
Quandl::Database.all.current_page
=> 1
Quandl::Database.all['current_page']
=> 1
```

As a convenience method lists can also return their data in CSV form. To do this simply issue the .to_csv method on a list:

```ruby
require 'quandl'
databases = Quandl::Database.all.to_csv
=> "Id,Name,Database Code,Description,Datasets Count,Downloads,Premium,Image,Bundle Ids,Plan ...
```

## Additional Links

* [Quandl](https://www.quandl.com)
* [Quandl Tools](https://www.quandl.com/tools/api)
