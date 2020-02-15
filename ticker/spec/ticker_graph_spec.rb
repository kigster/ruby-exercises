# frozen_string_literal: true

require_relative '../lib/ticker_graph'
require 'rspec'
require 'rspec/its'

RSpec.describe TickerGraph do
  let(:input_hash) { nil }
  subject(:graph) { described_class.new(input_hash) }

  its(:edges) { should be_empty }
  its(:ticker_tuples) { should be_empty }

  context 'with tuples' do
    let(:input_hash) {
      {
        'BTC-ETH' => 200.0,
        'BTC-USD' => 7000.0,
        'ETH-USD' => 15.0,
        'ETH-LTC' => 10.0,
        'LTC-EUR' => 12.0,
        'EUR-USD' => 1.3
      }
    }
    its(:ticker_tuples) { should_not be_empty }
    its(:ticker_tuples) { should include TickerGraph::TickerTuple.new('LTC-EUR', 12.0) }

    context 'ticker-tuple' do
      subject(:tuple) { graph.ticker_tuples.find { |t| t.tuple == 'BTC-ETH' } }
      its(:from) { should eq 'BTC' }
      its(:to) { should eq 'ETH' }
      context 'graph' do
        subject { graph }
        its(:edges) { should include Set.new(%w(BTC ETH)) }
        it 'should print edges' do
          expect(graph.print_edges).to_not be_nil
        end
      end
    end
  end
end
