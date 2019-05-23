require_relative '../lib/tree'
require 'rspec'
require 'rspec/its'

RSpec.describe Tree do
  let(:root_value) { 1000 }
  let(:root_node) { Node.new(root_value) }

  subject(:builder) { described_class.new(root_node) }

  its(:root) { should be_a_kind_of(Node) }


end
