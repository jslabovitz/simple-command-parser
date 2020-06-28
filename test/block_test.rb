require_relative 'test'

class BlockTest < Test

  def setup
    $result = {}
  end

  def run_command(args)
    SimpleCommand.run(args) do
      global format: 'd' do
        $result[:format] = @format
      end
      command 'add', fudge: 0 do |args|
        $result[:fudge] = @fudge
        $result[:args] = args
      end
    end
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