# Cloud Kitchen Order Fulfillment Simulation

See [CLAUDE.MD](CLAUDE.md) file for Prompt Instructions to Claude CLI while building this gem.

A real-time kitchen order processing system that simulates the complete lifecycle of food orders from receipt through delivery, including shelf management, order decay, and courier dispatch.

## Features

✅ **Real-time Order Processing**: Configurable order ingestion rate (default: 2 orders/second)  
✅ **State Machine**: Orders transition through received → cooking → ready → picked_up → delivered  
✅ **Shelf Management**: Temperature-specific shelves (hot, cold, frozen) plus overflow shelf  
✅ **Order Decay**: Food value deteriorates over time with different rates per shelf type  
✅ **Courier System**: Random travel times (2-6 seconds) with concurrent deliveries  
✅ **Overflow Logic**: Intelligent order movement and discard when shelves are full  
✅ **Real-time Logging**: Event-driven output with complete shelf contents display  
✅ **Comprehensive Testing**: Full RSpec test suite covering all components

## Requirements Met

This implementation fully satisfies all requirements from the original problem specification:

- ✅ Real-time system with 2 orders/second default rate (configurable)
- ✅ Instant cooking upon order receipt
- ✅ Proper shelf placement with temperature matching
- ✅ Overflow shelf handling with capacity management  
- ✅ Order value calculation with decay formula: `(shelfLife - decayRate * orderAge * shelfDecayModifier) / shelfLife`
- ✅ Courier dispatch with random 2-6 second arrival times
- ✅ Instant pickup and delivery mechanics
- ✅ Shelf capacity enforcement (Hot: 10, Cold: 10, Frozen: 10, Overflow: 15)
- ✅ Overflow management: move orders to preferred shelves when possible, discard random orders when not
- ✅ Zero-value order expiration and removal
- ✅ System termination when all orders are processed
- ✅ Real-time event logging with shelf contents display

## Installation

```bash
cd cloud-kitchen-claude
bundle install
```

## Usage

### Basic Usage

```bash
# Run with default settings (2 orders/second, 5 couriers)
./bin/kitchen orders.json

# Custom order rate
./bin/kitchen --rate 3.5 orders.json

# Custom courier count
./bin/kitchen --couriers 8 orders.json

# Combined options
./bin/kitchen --rate 1.5 --couriers 10 orders.json
```

### Command Line Options

- `-r, --rate RATE`: Orders per second (default: 2.0)
- `-c, --couriers N`: Number of couriers (default: 5)  
- `-h, --help`: Show help message

## Architecture

### Core Components

**Order**: State machine with value decay calculation and lifecycle management
- States: received → cooking → ready → picked_up → delivered → expired
- Value formula: `(shelfLife - decayRate * age * shelfDecayModifier) / shelfLife`
- Automatic expiration when value reaches zero

**Shelf**: Temperature-specific storage with capacity limits and decay modifiers
- Temperature shelves: decay modifier = 1
- Overflow shelf: decay modifier = 2 (faster decay)
- Automatic removal of expired orders

**ShelfManager**: Intelligent shelf placement and overflow management
- Tries preferred temperature shelf first
- Falls back to overflow shelf if temperature shelf is full
- Moves orders from overflow to preferred shelves when space becomes available
- Discards random orders from overflow when no moves are possible

**Courier**: Asynchronous pickup and delivery with random timing
- Random travel time: 2-6 seconds
- State management: ready → assigned → delivering → ready
- Concurrent operation with multiple couriers

**Kitchen**: Central coordinator with event-driven architecture
- Real-time order ingestion at configurable rates
- Background shelf maintenance (removes expired orders)
- Statistics tracking and real-time logging
- Automatic termination when all orders complete

### Design Patterns Used

- **State Machine**: Orders follow strict state transitions
- **Observer Pattern**: Components listen for lifecycle events
- **Command Pattern**: CLI interface with multiple commands
- **Factory Pattern**: Order creation from JSON data
- **Strategy Pattern**: Different shelf decay strategies

## Testing

```bash
# Run all tests
bundle exec rspec

# Run with detailed output
bundle exec rspec --format documentation

# Run specific test file
bundle exec rspec spec/order_spec.rb

# Run specific test
bundle exec rspec spec/kitchen_spec.rb:40
```

### Test Coverage

- **Order**: State transitions, value calculation, decay, expiration
- **Shelf**: Capacity limits, temperature matching, order management
- **ShelfManager**: Overflow logic, order movement, discard behavior
- **Courier**: Assignment, pickup, delivery timing
- **Kitchen**: Order processing, statistics, event logging

## Sample Output

```
🍳 Kitchen starting with 6 orders at 2.0 orders/second
17:25:14.123 📥 Order received: Order(a8cfcb76, Banana Split, frozen, age: 0.0s, value: 1.0, state: received)
17:25:14.123 🥶 Order placed on frozen shelf: Order(a8cfcb76, Banana Split, frozen, age: 0.0s, value: 1.0, state: ready)
17:25:14.123 🚗 Courier courier-1 dispatched: Order(a8cfcb76, Banana Split, frozen, age: 0.0s, value: 1.0, state: ready)

📊 Current shelf contents:
  Hot: 0/10 - 
  Cold: 0/10 - 
  Frozen: 1/10 - Banana Split
  Overflow: 0/15 - 

17:25:17.456 📋 Order picked up: Order(a8cfcb76, Banana Split, frozen, age: 3.33s, value: 0.895, state: picked_up)
17:25:17.456 ✅ Order delivered: Order(a8cfcb76, Banana Split, frozen, age: 3.33s, value: 0.895, state: delivered)
```

## Design Decisions

### Overflow Shelf Management

When the overflow shelf is full and a new order needs placement:

1. **First**: Try to move an existing overflow order to its preferred temperature shelf
2. **Second**: If no moves are possible, discard a random order from overflow to make space
3. **Last**: If still no space, mark the new order as wasted/expired

This approach prioritizes keeping orders on their preferred shelves when possible while ensuring new orders can still be processed.

### Concurrent Processing

- Orders are processed concurrently with separate threads for:
  - Order ingestion (main thread)
  - Shelf value updates (background thread)  
  - Courier travel and pickup (per-courier threads)
  - Order lifecycle monitoring (per-order threads)

### Real-time Event Logging

Every significant event is logged with:
- Timestamp
- Event description with emoji
- Order details (ID, name, age, current value)
- Complete shelf contents after each placement/pickup

## Performance Characteristics

- **Memory**: O(total_orders) for active orders on shelves
- **CPU**: Minimal overhead with efficient concurrent processing
- **I/O**: Event logging only, no database or file system dependencies
- **Scalability**: Handles high order rates with configurable courier pools

## Error Handling

- Invalid order files: Graceful exit with error message
- Malformed JSON: Individual order parsing failures are logged and skipped
- Interrupted execution: Clean shutdown on Ctrl+C with final statistics

---

**Implementation Status**: ✅ Complete - All requirements fully implemented with comprehensive test coverage
