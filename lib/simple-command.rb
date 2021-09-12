require 'hashstruct'
require 'simple_option_parser'

require 'simple-command/version'

class SimpleCommand

  class Error < Exception; end

  def self.run(args=ARGV, &block)
    @commands = {}
    class_eval(&block) if block_given?
    if Command.command_classes
      Command.command_classes.each do |klass|
        @commands[klass.command_name] = klass
      end
    end
    begin
      command_name = args.shift or raise Error, "No subcommand given"
      command = @commands[command_name] or raise Error, "Command not found: #{command_name.inspect}"
      options = SimpleOptionParser.parse(args)
      command.new(**options).run(args)
    rescue Error => e
      warn "Error: #{e}"
      exit(1)
    end
  end

  class Command

    def self.inherited(subclass)
      @command_classes ||= []
      @command_classes << subclass
    end

    def self.command_classes
      @command_classes || []
    end

    def self.option(name, default: nil)
      attr_accessor(name)
      unless default.nil?
        @defaults ||= {}
        @defaults[name] = default
      end
    end

    def self.defaults
      @defaults || {}
    end

    def self.command_name
      @command_name ||= self.
        to_s.
        split('::').
        last.
        sub(/Command?$/, '').
        split(/(?=[A-Z])/).
        join('-').
        downcase
    end

    def initialize(**params)
      self.class.defaults.merge(params).each do |key, value|
        send("#{key}=", value)
      end
    end

    def run(args)
      raise Unimplemented
    end

  end

end