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
        name = args.shift or raise Error, "No subcommand given"
        klass = @commands[name] or raise Error, "Command not found: #{name.inspect}"
        options = HashStruct.new(SimpleOptionParser.parse(args))
        klass.new(options).run(args)
      rescue Error => e
        warn "Error: #{e}"
        exit(1)
      end
    end

  end

  def self.register(*args)
    Manager.register(*args)
  end

  def initialize(params={})
    params.each do |key, value|
      raise Error, "Option not found: #{key.to_s.inspect}" unless respond_to?(key)
      send("#{key}=", value)
    end
  end

  def run(args)
    raise NotImplementedError
  end

end