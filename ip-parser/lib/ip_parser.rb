# frozen_string_literal: true

class IPParser < Struct.new(:ip)
end

require 'ipv4_parser'
require 'ipv6_parser'
