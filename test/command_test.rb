require 'minitest/autorun'
require 'minitest/power_assert'

require 'simple-command-parser'

class Test < Minitest::Test

  class Command < Simple::CommandParser::Command

    attr_accessor :scale
    attr_accessor :result

    def self.defaults
      super.merge(
        scale: 1,
      )
    end

  end

  class Add < Command

    attr_accessor :format
    attr_accessor :offset

    def self.defaults
      super.merge(
        format: 'd',
        offset: 0,
      )
    end

    def run(args)
      @result = "%#{@format}" % ((@offset + args.map(&:to_i).inject(&:+)) * @scale)
    end

  end

  def setup
    @parser = Simple::CommandParser.new
  end

  def test_simple
    result = @parser.run(%w{add 1 2 3}).result
    assert { result == '6' }
  end

  def test_offset
    result = @parser.run(%w{add --offset=10 1 2 3}).result
    assert { result == '16' }
  end

  def test_format
    result = @parser.run(%w{add --offset=10 --format=x 1 2 3}).result
    assert { result == '10' }
  end

  def test_global
    result = @parser.run(%w{add --scale=2 1 2 3}).result
    assert { result == '12' }
  end

  def test_usage
    begin
      result = @parser.run(%w{bad})&.result
    rescue Simple::CommandParser::UsageError
      nil
    end
    assert { result == nil }
  end

end