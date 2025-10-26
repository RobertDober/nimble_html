#!/usr/bin/env ruby

require 'active_support/all'
require 'awesome_print'
require 'ex_aequo/base'
require 'fileutils'
require 'json'

module Parse extend self
  def parse(file)
    cache[file] ||= JSON.parse(File.read(file))
  end

  def cache = Hash.new
end

module Emitter extend self
  def make_elixir_test(file:, tests:)
    target_name = file.gsub(/\.test\z/, '_test').underscore
    module_name =
      target_name
      .split("/")
      .map(&:camelize)
      .join(".")
  
    compile_and_emit(module_name:, target_name:, tests:)
  end

  private
  def compile_and_emit(module_name:, target_name:, tests:)
    $stderr.puts({target_name:, module_name:}.inspect)
    data = compile(tests)
    output = prefix(module_name) + data + suffix

    write_file(name: "#{target_name}.exs", output:)
  end

  def compile(file)
    []
  end


  def prefix(name)
    [
      "defmodule #{name} do",
      "  use Support.AcceptanceTestCase",
      ""
    ]
  end

  def suffix
    [
      "end",
      "",
      "# SPDX-License-Identifier: Apache-2.0"
    ]
  end

  def write_file(name:, output:)
    FileUtils.mkdir_p(File.dirname(name))
    File.open(name, "w") { it.puts(output) }
  end
end

SPEC_DIR="test/html5lib-tests"
Dir.glob(File.join("**/*.test")).each do |file|
  doc = Parse.parse(file)
  tests = doc['tests']
  next unless tests
  Emitter.make_elixir_test(file:, tests:)
  # p(file:, type: tests.class, size: tests.size)
  # require "debug"; binding.break
end
# SPDX-License-Identifier: Apache-2.0
