require 'hashstruct'
require 'simple_option_parser'

class SimpleCommand

  class Error < Exception; end

  class Manager

    def self.register(klass, name)
      @commands ||= {}
      @commands[name] = klass
    end

    def self.run(args)
      begin
        command = parse(args)
        command.run(args)
      rescue Error => e
        warn "Error: #{e}"
        exit(1)
      end
    end

    def self.parse(args)
      name = args.shift or raise Error, "No subcommand given"
      klass = @commands[name] or raise Error, "Command not found: #{name.inspect}"
      command = klass.new
      command.parse(args)
      command.setup
      command
    end

  end

  def self.register(*args)
    Manager.register(*args)
  end

  def initialize(params={})
    params.each { |k, v| send("#{k}=", v) }
  end

  def parse(args)
    HashStruct.new(SimpleOptionParser.parse(args)).each do |key, value|
      begin
        ;;pp(key: value)
        send("#{key}=", value)
      rescue NoMethodError => e
        raise Error, "Options not found: #{key.to_s.inspect}"
      end
    end
  end

  def setup
    # optionally implemented by subclass
  end

  def run(args)
    raise NotImplementedError
  end

end