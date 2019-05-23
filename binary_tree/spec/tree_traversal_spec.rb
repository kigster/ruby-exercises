require_relative '../lib/tree_traversal'
require_relative '../lib/binary_node'
require 'rspec'
require 'rspec/its'

class BinaryNode
  include TreeTraversal
  def visit
    value
  end
end

RSpec.describe BinaryNode do
  let(:root_value) { 1 }
  let(:left_node) { described_class.new(2) }
  let(:right_node) { described_class.new(3) }
  subject(:root_node) { described_class.new(root_value, left_node, right_node) }
  its(:left) { should eq left_node }
  its(:right) { should eq right_node }

  context 'in_order_traversal' do
    subject(:result) { root_node.in_order_traversal(result_proc: ->(*ary) { ary.flatten.compact.sum }) }
    it { is_expected.to eq 6 }
  end
end
