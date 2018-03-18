require 'simple-command'

class DoIt < SimpleCommand

  register self, 'do-it'

  def run(args)
    puts 'Done.'
  end

end

SimpleCommand::Manager.run(ARGV)