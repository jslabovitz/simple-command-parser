require_relative 'test'

class AddCommand < SimpleCommand

  # CommandName = 'add'
  CommandDefaults = {
    format: 'd',
    fudge: 0,
  }

  def run(args, options)
    $result[:format] = options.format
    $result[:fudge] = options.fudge
    $result[:args] = args
  end

end

class ClassTest < Test

  def setup
    $result = {}
  end

  def run_command(args)
    SimpleCommand.run(args)
  end

  def test_defaults
    run_command(%w{add 1 2 3})
    assert { $result[:args] }
    assert { $result[:args].map(&:to_i) == [1, 2, 3] }
    assert { $result[:fudge] == 0 }
    assert { $result[:format] == 'd' }
  end

  def test_options
    run_command(%w{add --format=o --fudge=10 1 2 3})
    assert { $result[:args] }
    assert { $result[:args].map(&:to_i) == [1, 2, 3] }
    assert { $result[:fudge] == 10 }
    assert { $result[:format] == 'o' }
  end

end