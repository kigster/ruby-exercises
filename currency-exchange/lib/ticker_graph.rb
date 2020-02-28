# frozen_string_literal: true

require 'set'
require 'stringio'
require 'colored2'

class TickerGraph
  class TickerTuple < Struct.new(:tuple, :amount)
    attr_accessor :from, :to

    def initialize(*args)
      super(*args)
      self.from, self.to = args.first.split(/-/)
    end

    def ticker
      "#{from}-#{to}"
    end
  end

  attr_accessor :ticker_tuples, :currencies, :tuple_prices, :graph

  def initialize(ticker_tuple_hash = nil)
    self.currencies    = {}
    self.tuple_prices  = {}
    self.ticker_tuples = []
    self.graph         = {}

    ticker_tuple_hash&.each_pair do |tuple, amount|
      ticker_tuple = TickerTuple.new(tuple, amount)
      ticker_tuples << ticker_tuple
      tuple_prices[ticker_tuple.ticker] = ticker_tuple.amount
      register_edge(ticker_tuple)
    end
  end

  def resolve!
    populate_currencies!
    walk_edges!
    self
  end

  def to_s
    "\n" + as_string
  end

  private

  def walk_edges!(from = first_ticker, sub_graph = {})
    currencies[from]&.each_pair do |to, amount|
      next if from == to

      ticker = "#{from}-#{to}"
      next if sub_graph.key? ticker

      sub_graph[ticker] = amount
      walk_edges!(to, sub_graph)
    end

    graph.merge!(sub_graph)
  end

  def populate_currencies!(from = first_ticker)
    return if currencies.keys.all? { |key| currencies[key].size == ticker_tuples.size }

    currencies[from].keys.each do |to|
      next if currencies[to].nil?

      currencies[to].keys.each do |transient_to|
        next if currencies[from].key?(transient_to)

        currencies[from][transient_to] = (currencies[from][to] * currencies[to][transient_to]).to_f.round(4)
        populate_currencies!(to)
      end
    end
  end

  def first_ticker
    currencies.keys.first
  end

  def as_string
    out = StringIO.new
    graph.each_pair do |ticker, amount|
      out.print ticker.bold.green

      if amount
        out.print ' ————▶ '
        out.puts sprintf('%9.4f', amount).bold.yellow
      else
        out.puts
      end
    end
    out.string
  end

  private

  def register_edge(tuple)
    currencies[tuple.from] ||= {}
    currencies[tuple.from][tuple.to] = tuple.amount
  end
end
