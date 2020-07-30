require 'hashstruct'
require 'simple_option_parser'

require 'simple-command/version'

class SimpleCommand

  class Error < Exception; end

  CommandNameConst = 'CommandName'
  CommandDefaultsConst = 'CommandDefaults'

  CommandName = nil
  CommandDefaults = {}

  def self.inherited(subclass)
    @command_classes ||= []
    @command_classes << subclass
  end

  def self.command_classes
    @command_classes ||= []
    @command_classes
  end

  def self.run(args=ARGV, &block)
    new(&block).run(args)
  end

  def initialize(args=ARGV, &block)
    @commands = {}
    @defaults = {}
    @globals = {}
    if block_given?
      instance_eval(&block)
    else
      self.class.command_classes.each do |klass|
        name = klass.const_get(CommandNameConst) || derived_command_name(klass)
        @commands[name] = klass
        @defaults[name] = klass.const_get(CommandDefaultsConst)
      end
    end
  end

  def derived_command_name(klass)
    klass.to_s.split('::').last.sub(/Command?$/, '').downcase
  end

  def run(argv=ARGV)
    begin
      name = argv.shift or raise Error, "No subcommand given"
      command = @commands[name] or raise Error, "Command not found: #{name.inspect}"
      defaults = @defaults[name] || {}
      options = HashStruct.new(@globals.merge(SimpleOptionParser.parse(argv, defaults)))
      case command
      when Proc
        options.each do |key, value|
          instance_variable_set("@#{key}", value)
        end
        @global_block.call
        command.call(argv)
      when Class
        #FIXME: does not handle global block
        command.new.run(argv, options)
      else
        raise
      end
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
    @commands[name] = block
    @defaults[name] = defaults
  end

end