#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/ticker'

from_currency = ARGV[0] || 'BTC'
to_currency   = ARGV[1] || 'ETH'
amount        = ARGV[2] || 0.5

puts "Checking prices for #{from_currency} to #{to_currency} amount #{amount}"

puts Ticker.new(from:   from_currency,
                to:     to_currency,
                amount: amount).price

#  BTC --> ETH ---> USD
#  |                 ^
#  |-----------------|
#  V
#  USD
