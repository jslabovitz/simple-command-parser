require 'simple_option_parser'

module Simple

  class CommandParser

    class UsageError < StandardError; end

    def self.run(*args)
      new.run(*args)
    end

    def run(args=ARGV, **defaults)
      cmd_name = args.shift or raise UsageError, "No command given"
      cmd_class = Command.find_command(cmd_name) or raise UsageError, "Unknown command: #{cmd_name.inspect}"
      options = defaults.merge(cmd_class.defaults.merge(SimpleOptionParser.parse(args)))
      cmd_class.new(options).tap { |cmd| cmd.run(args) }
    end

    class Command

      def self.inherited(klass)
        @@command_classes ||= []
        @@command_classes << klass
      end

      def self.find_command(name)
        @@command_classes ||= []
        map = @@command_classes.select { |k| k.subclasses.empty? }.map { |k| [k.command_name, k] }.to_h
        map[name]
      end

      def self.command_name
        name.to_s.
          split('::').last.
          gsub(/([a-z])([A-Z])/, '\1-\2').
          downcase
      end

      def self.defaults
        {}
      end

      def initialize(options={})
        options.each do |key, value|
          raise CommandParser::UsageError, "Unknown option: #{key.inspect}" unless respond_to?(key)
          send("#{key}=", value)
        end
      end

    end

  end

end