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

    if ticker_tuple_hash
      ticker_tuple_hash.each_pair do |tuple, ticker|
        ticker_tuple = TickerTuple.new(tuple, ticker)
        self.ticker_tuples << ticker_tuple
        register_edge(ticker_tuple.from, ticker_tuple.to)
      end
    end
  end

  def walk_edges(from = nil, path = [])
    if from
      tos = currencies[from]
    else
      tos = currencies.keys
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
    self.edges << Set.new([from, to])
    self.edges << Set.new([to, from])

    self.currencies[from] ||= Set.new
    self.currencies[to]   ||= Set.new

    self.currencies[from] << to
    self.currencies[to] << from
  end

end
