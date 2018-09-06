require 'hashstruct'
require 'simple_option_parser'

class SimpleCommand

  class Error < Exception; end

  def self.run(args=ARGV, &block)
    new(&block).run(args)
  end

  def initialize(args=ARGV, &block)
    @commands = {}
    @globals = {}
    instance_eval(&block)
  end

  def run(argv=ARGV)
    begin
      name = argv.shift or raise Error, "No subcommand given"
      command = @commands[name] or raise Error, "Command not found: #{name.inspect}"
      defaults, block = *command
      HashStruct.new(@globals.merge(SimpleOptionParser.parse(argv, defaults))).each do |key, value|
        instance_variable_set("@#{key}", value)
      end
      @global_block.call
      block.call(argv)
    rescue Error => e
      warn "Error: #{e}"
      exit(1)
    end
  end

  def global(globals={}, &block)
    @globals = globals
    @global_block = block
  end

  def command(name, defaults={}, &block)
    @commands[name] = [defaults, block]
  end

end