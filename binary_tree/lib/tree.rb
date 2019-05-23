require_relative 'node'

class Tree
  attr_accessor :root

  def initialize(root = nil)
    self.root = root
  end

  def visit(node)
    node.visited = true
  end

end

