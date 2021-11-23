require 'minitest/autorun'
require 'minitest/power_assert'

require 'simple-command'

class Test < MiniTest::Test

  class Command < SimpleCommand::Command

    def self.defaults
      super.merge(
        scale: 1,
      )
    end

  end

  class AddCommand < Command

    def self.defaults
      super.merge(
        format: 'd',
        offset: 0,
      )
    end

    def run(args)
      "%#{@format}" % ((@offset + args.map(&:to_i).inject(&:+)) * @scale)
    end

  end

  def setup
    @commander = SimpleCommand::Commander.new(
      'add' => AddCommand,
    )
  end

  def test_simple
    result = @commander.run(%w{add 1 2 3})
    assert { result == '6' }
  end

  def test_offset
    result = @commander.run(%w{add --offset=10 1 2 3})
    assert { result == '16' }
  end

  def test_format
    result = @commander.run(%w{add --offset=10 --format=x 1 2 3})
    assert { result == '10' }
  end

  def test_global
    result = @commander.run(%w{add --scale=2 1 2 3})
    assert { result == '12' }
  end

end