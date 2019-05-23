class Graph
  attr_accessor :nodes

  def initialize(nodes = Set.new)
    @nodes = nodes
  end
end

class Edge
  attr_accessor :from, :to, :weight
end

class Node
  attr_accessor :name, :edges
end
