require 'simple-command'

SimpleCommand.run do

  global format: 'd' do
    @format = "%#{@format}"
  end

  command 'add', fudge: 0 do |args|
    @total = 0
    args.map(&:to_i).each do |n|
      @total += n
    end
    @total += @fudge
    puts "Total: #{@format}" % @total
  end

end