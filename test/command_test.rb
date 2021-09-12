require 'minitest/autorun'
require 'minitest/power_assert'

require 'simple-command'

class AddCommand < SimpleCommand::Command

  option :format, default: 'd'
  option :offset, default: 0

  def run(args)
    $result = "%#{@format}" % (@offset + args.map(&:to_i).inject(&:+))
  end

end

class Test < MiniTest::Test

  def setup
    $result = nil
  end

  def test_simple
    SimpleCommand.run(%w{add 1 2 3})
    assert { $result == '6' }
  end

  def test_offset
    SimpleCommand.run(%w{add --offset=10 1 2 3})
    assert { $result == '16' }
  end

  def test_format
    SimpleCommand.run(%w{add --offset=10 --format=x 1 2 3})
    assert { $result == '10' }
  end

end