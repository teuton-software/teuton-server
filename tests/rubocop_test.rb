#!/usr/bin/env ruby

require 'minitest/autorun'

# MiniTest Rubocop
class RubocopTest < Minitest::Test
  def setup
    @files = {}

    @files[:rake] = []
    @files[:rake] << 'Rakefile'
    @files[:rake] << 'tasks/build.rb'
    @files[:rake] << 'tasks/install.rb'
    @files[:rake] << 'tasks/utils.rb'

    @files[:lib] = []
    @files[:lib] << 'lib/teuton-server.rb'
    @files[:lib] << 'lib/teuton-server/application.rb'
    @files[:lib] << 'lib/teuton-server/cli.rb'
    @files[:lib] << 'lib/teuton-server/input_loader.rb'
  end

  def test_rubocop_rake
    @files[:rake].each do |file|
      output = `rubocop #{file}`
      puts "[DEBUG] #{file}" if $?.exitstatus > 0
      assert_equal 0, $?.exitstatus
    end
  end

  def test_rubocop_lib
    @files[:lib].each do |file|
      output = `rubocop #{file}`
      puts "[DEBUG] #{file}" if $?.exitstatus > 0
      assert_equal 0, $?.exitstatus
    end
  end
end
