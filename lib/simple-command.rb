require 'simple_option_parser'

class SimpleCommand

  class Error < Exception; end

  class Commander

    def self.run(*args)
      new.run(*args)
    end

    def run(args=ARGV, **defaults)
      begin
        name = args.shift or raise Error, "No command given"
        name = name.split('-').map(&:capitalize).join
        klass = Command.command_classes.find { |c| name == c.to_s.split('::').last }
        raise Error, "Command not found: #{name.inspect}" unless klass
        options = SimpleOptionParser.parse(args)
        command = klass.new(defaults.merge(klass.defaults.merge(options)))
        command.run(args)
      rescue Error => e
        warn "Error: #{e}"
        exit(1)
      end
    end

  end

  class Command

    def self.inherited(klass)
      @@command_classes ||= []
      @@command_classes << klass
    end

    def self.command_classes
      defined?(@@command_classes) ? @@command_classes : []
    end

    def self.defaults
      {}
    end

    def initialize(params={})
      params.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

  end

end