require 'simple-command'

class DoIt < SimpleCommand

  register_command 'do-it', when: 'now'

  attr_accessor :when

  def run(args)
    thing = args.shift || 'something'
    puts "Doing #{thing} #{@when}."
  end

end

SimpleCommand::Manager.run(ARGV)