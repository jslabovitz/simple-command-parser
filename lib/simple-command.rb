require 'simple_option_parser'

class SimpleCommand

  class Error < Exception; end

  class Commander

    def initialize(**commands)
      @commands = commands
    end

    def run(args=ARGV, **defaults)
      begin
        name = args.shift or raise Error, "No command given"
        klass = command_class(name)
        options = SimpleOptionParser.parse(args)
        command = klass.new(defaults.merge(klass.defaults.merge(options)))
        command.run(args)
      rescue Error => e
        warn "Error: #{e}"
        exit(1)
      end
    end

    def command_class(name)
      klass = @commands[name]
      unless klass
        klass_name = name.split('-').map(&:capitalize).join
        klass = Command.subclasses.find { |c| c.to_s.split('::').last == klass_name }
      end
      raise Error, "Command not found: #{name.inspect}" unless klass
      klass
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