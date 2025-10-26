#!/usr/bin/env ruby

require 'awesome_print'
require 'ex_aequo/base'
require 'json'

module Parse extend self
  def parse(file)
    cache[file] ||= JSON.parse(File.read(file))
  end

  def cache = Hash.new
end
SPEC_DIR="test/html5lib-tests"
Dir.glob(File.join("**/*.test")).each do |file|
  doc = Parse.parse(file)
  tests = doc['tests']
  next unless tests
  make_elixir_test(file:, tests:)
  # p(file:, type: tests.class, size: tests.size)
  # require "debug"; binding.break
end
# SPDX-License-Identifier: Apache-2.0
