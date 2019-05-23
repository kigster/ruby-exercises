require_relative 'node'

class BinaryNode < Node

  def initialize(value, left = nil, right = nil)
    raise(ArgumentError, 'Invalid left or right') unless (left.nil? || left.is_a?(self.class)) && (right.nil? || right.is_a?(self.class))
    super(value, [left, right], size: 2)
  end

  def left
    children[0]
  end

  def right
    children[1]
  end

end
