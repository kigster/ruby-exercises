# frozen_string_literal: true

require 'set'

class TickerGraph
  class TickerTuple < Struct.new(:tuple, :ticker)
    attr_accessor :from, :to

    def initialize(*args)
      super(*args)
      self.from, self.to = args.first.split(/-/)
    end
  end

  attr_accessor :ticker_tuples, :edges, :currencies

  def initialize(ticker_tuple_hash = nil)
    self.currencies    = {}
    self.edges         = []
    self.ticker_tuples = []

    ticker_tuple_hash&.each_pair do |tuple, ticker|
      ticker_tuple = TickerTuple.new(tuple, ticker)
      ticker_tuples << ticker_tuple
      register_edge(ticker_tuple.from, ticker_tuple.to)
    end
  end

  def walk_edges(from = nil, path = [])
    tos = if from
            currencies[from]
          else
            currencies.keys
          end

    path << from

    tos.each do |to|
      if path.include?(to)
        next
      else
        walk_edges(to, path.dup)
      end
    end
  end

  def print_edges
    edges.each do |edge|
      puts edge.to_a.join('-')
    end
  end

  private

  def register_edge(from, to)
    edges << Set.new([from, to])
    edges << Set.new([to, from])

    currencies[from] ||= Set.new
    currencies[to]   ||= Set.new

    currencies[from] << to
    currencies[to] << from
  end
end
