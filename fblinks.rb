#!/usr/bin/ruby

require 'koala'
require 'cinch'

ACCESS_TOKEN = ENV['FB_TOKEN']

class Reporter; end;
class IrcReporter < Reporter
  attr_accessor :bot
  attr_accessor :thread

  def initialize
    @bot = Cinch::Bot.new do
      configure do |c|
        c.server   = ENV['IRC_NETWORK']
        c.channels = ["#scanner"]
        c.nick     = 'darkly'
      end
    end
    @thread = Thread.new { @bot.start }
  end

  def report message
    @bot.channels.each { |channel| channel.send message }
  end
end

class Id
  attr_accessor :id
end

class IncrementingId < Id
  def initialize
    @id = 1028597720544783
  end

  def mutate!
    @id += 1
  end
end

class MutatableId < Id
  attr_accessor :history

  def initialize
    @id = '1028597720543405'
    @history = [@id]
  end

  def mutate!
    mutating_index = rand(@id.length - 1) + 1
    mutated_value  = @id[mutating_index].to_i + (rand(2).zero? ? 1 : -1)

    mutated_value = [0, mutated_value].max
    mutated_value = [9, mutated_value].min

    @id[mutating_index] = mutated_value.to_s

    if @history.include?(@id)
      mutate!
    else
      @history << @id
    end

    true
  end
end


graph    = Koala::Facebook::API.new ACCESS_TOKEN
reporter = IrcReporter.new
graph_id = IncrementingId.new

while true
  begin
    graph_id.mutate!
    object = graph.get_object graph_id.id

    puts object.inspect

    next unless object.key? 'url'
    reporter.report "Found object #{graph_id.id} clicked #{object['created_time']}: #{object['url']}"
  rescue
    puts "ID #{graph_id.id} doesn't point to a valid object."
    # Failed, mutate and try again
  end
  sleep 2
end