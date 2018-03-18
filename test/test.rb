require 'simple-command'

class DoIt < SimpleCommand

  register_command 'do-it'

  def run(args)
    puts 'Done.'
  end

end

SimpleCommand::Manager.run(ARGV)