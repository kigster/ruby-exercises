# Currency Conversions

Here we are given some number of Currency ticker pairs and their corresponding exchange rate.

Not all tickers are mapped to every other ticker, so we have to figure out how to walk the graph and populate it for each ticker.

For instance:

```ruby
exchange_rates = {
  'USD-CAN' => 1.5,
  'CAN-AUS' => 1.1
}
```

Here we are not given direct exchange rate between `USD` and `AUS`, but we can compute it by going through `CAN`.


In this case we want to see the following output:

```ruby
USD-CAN ————▶    1.5000
CAN-AUS ————▶    1.1000
USD-AUS ————▶    1.6500
```

## Solution

Provided solution offers a class `TickerGraph` that can be used as follows:

```ruby
TickerGraph.new({
                    'USD-CAN' => 1.5,
                    'CAN-AUS' => 1.1
                }).resolve!
=>
USD-CAN ————▶    1.5000
CAN-AUS ————▶    1.1000
USD-AUS ————▶    1.6500
```

