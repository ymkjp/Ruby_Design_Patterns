require 'webrick'

class HelloServer < WEBrick::GenericServer
    def run(socket)
        socket.print('Hello TCP/IP world')
    end
end
