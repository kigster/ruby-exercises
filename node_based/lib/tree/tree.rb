require_relative 'node'

class Tree
  attr_accessor :root

  def initialize(root = nil)
    self.root = root
  end

  def in_order_traversal(node: self.root, level: 0, &block)
    if node
      in_order_traversal(node: node.left, level: level + 1, &block) if node.left
      block.call(node, level) if block_given?
      in_order_traversal(node: node.right, level: level + 1, &block) if node.right
    end
  end
end

