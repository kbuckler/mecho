require 'eventmachine'
require 'lib/mecho/server'

class Mecho
  def self.start
    EM.run do
      EventMachine::start_server "127.0.0.1", 8000, Mecho::Server
    end
  end
end
