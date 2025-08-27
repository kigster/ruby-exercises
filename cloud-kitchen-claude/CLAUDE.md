# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

### Development Commands
- `bundle install` - Install gem dependencies
- `bundle exec rake` - Run default tasks (spec and rubocop)
- `bundle exec rake spec` - Run all RSpec tests
- `bundle exec rake rubocop` - Run RuboCop linter
- `bundle exec rake clean` - Clean generated folders (pkg, coverage, log)
- `bundle exec rake doc` - Generate YARD documentation

### Running the Application
- `./bin/kitchen-ctl cook orders.json` - Start kitchen simulation with orders file
- `./bin/kitchen-ctl cook --rate 2.0` - Process orders at specified rate per second
- `./bin/kitchen-ctl version` - Display version information

### Running Tests
- `bundle exec rspec` - Run all tests
- `bundle exec rspec spec/integration/` - Run integration tests only
- `bundle exec rspec spec/lib/` - Run unit tests only
- `bundle exec rspec spec/path/to/specific_spec.rb` - Run specific test file

## Architecture Overview

This is a **cloud kitchen order fulfillment simulation** that models a real-time order processing pipeline using event-driven architecture.

### Core Components

**Dispatcher**: Central orchestrator that coordinates the entire order lifecycle. Uses event publishing/subscription pattern to coordinate between Kitchen and CourierManager. Maintains order counters and manages background threads for real-time processing.

**Kitchen**: Manages cooking operations and shelf placement. Contains a `ShelfManager` for handling different temperature shelves (hot, cold, frozen, overflow) with decay simulation. Processes orders asynchronously with calculated cooking times.

**CourierManager**: Handles courier pool and dispatch logic. Manages courier lifecycle (ready → assigned → delivering → ready) and coordinates order pickup/delivery timing.

**Order State Machine**: Orders follow strict state transitions: `received → cooking → ready → picked_up → delivered`. Uses AASM gem for state management with automatic timestamp logging.

### Event System
Uses `ventable` gem for event publishing. Key events:
- `OrderReceivedEvent` → starts cooking
- `OrderCookedEvent` → places on shelf 
- `OrderReadyEvent` → dispatches courier
- `OrderPickedUpEvent` → removes from shelf
- `OrderDeliveredEvent` → completes order

### Real-time Simulation Features
- **Order decay**: Food value decreases over time based on shelf type and decay rates
- **Shelf overflow**: When temperature-specific shelves are full, orders go to overflow shelf with accelerated decay
- **Concurrent processing**: Background threads handle cooking, shelf updates, and courier dispatching
- **Statistics tracking**: Real-time counters for all order states and shelf occupancy

### Key Design Patterns
- **Observer pattern**: Components subscribe to order lifecycle events
- **State machine**: Orders maintain strict state transitions with timing
- **Command pattern**: CLI commands handle different operational modes
- **Dependency injection**: Uses dry-rb ecosystem for configuration and containers
- **Event sourcing**: All state changes are event-driven with timing logs

### Data Flow
1. Orders imported from JSON → `OrderReceivedEvent`
2. Kitchen starts cooking → background thread completion → `OrderCookedEvent` 
3. Order placed on appropriate shelf → `OrderReadyEvent`
4. CourierManager dispatches courier → pickup after travel time → `OrderPickedUpEvent`
5. Courier delivers after delivery time → `OrderDeliveredEvent`

### Dependencies
- **dry-rb ecosystem**: Configuration, dependency injection, types, structs
- **AASM**: State machine management
- **ventable**: Event publishing system  
- **TTY gems**: Terminal UI components (tables, boxes, colors)
- **RSpec + Aruba**: Testing framework with CLI integration testing