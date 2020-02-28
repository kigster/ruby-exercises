#!/usr/bin/env ruby -W0
# frozen_string_literal: true

require_relative '../lib/ticker_graph'
require 'awesome_print'
require 'colored2'

exchange_rates = {
  'BTC-ETH' => 0.6,
  "ETH-CBU" => 1.2,
  "CBU-AMH" => 0.1,
  "AMH-BTC" => 0.1
}

tg = TickerGraph.new(exchange_rates).resolve!

def h1(text)
  puts text.bold.blue.italic
  puts '—————————————————————————————————————————————————————'.blue.bold
end

h1 'Graph Hash'
ap tg.graph

h1 'Currency Hash'
ap tg.currencies

h1 'Ticker Graph #to_s'
puts tg
