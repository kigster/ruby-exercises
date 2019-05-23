class Node
  attr_accessor :children, :visited
  attr_reader :value, :size

  class << self
    def from_array(ary)
      ary.each do |value|
        Node.new(value)
      end
    end
  end

  DEFAULT_CHILDREN = 2

  def initialize(value, children = [], size: DEFAULT_CHILDREN)
    @size     = size
    @value    = value
    @children = children || Array(size) { nil }
  end

  def complete?
    num_children == size
  end

  def num_children
    existing_children.size
  end

  def existing_children
    children&.compact
  end

  def left
    children.first
  end

  def right
    children.last
  end

  def sum
    value + existing_children.map(&:sum)&.sum || 0
  end

end
