require_relative 'lru_cache'
require 'rspec'

RSpec.describe LRUCache do
  subject(:lru) { described_class.new }
  let(:key) { 'this-key' }
  let(:value) { 1_000_000 }a
  context 'read' do
    it 'should return nil for a non-existent value' do
      expect(lru.read(key)).to be_nil
    end
  end
end
a
