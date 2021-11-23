require 'simple_option_parser'

class SimpleCommand

  class Error < Exception; end

  class Commander

    def initialize(**commands)
      @commands = commands
    end

    def run(args=ARGV)
      begin
        name = args.shift or raise Error, "No command given"
        klass = @commands[name] or raise Error, "Command not found: #{name.inspect}"
        options = SimpleOptionParser.parse(args)
        command = klass.new(klass.defaults.merge(options))
        command.run(args)
      rescue Error => e
        warn "Error: #{e}"
        exit(1)
      end
    end

  end

  class Command

    def self.defaults
      {}
    end

    def initialize(params={})
      params.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    def run(args)
    end

  end

end