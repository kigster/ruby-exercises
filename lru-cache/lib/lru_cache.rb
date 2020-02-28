# frozen_string_literal: true

class LRUCache
  attr_accessor :size, :data, :recency

  def initialize(size = nil)
    self.size    = size
    self.data    = {}
    self.recency = {}
  end

  def read(key)
    update_recency(key)
    data[key]
  end

  def write(key, value)
    data[key] = value
    update_recency(key)

    if data.size > size
      oldest_timestamp = recency.values.min
      oldest_key       = recency.keys.find { |k| abs(recency[k] - oldest_timestamp) < 0.001 }
      data.delete(oldest_key)
      recency.delete(oldest_key)
    end

    value
  end

  private

  def update_recency(key)
    recency[key] = Time.now.to_f
  end
end
