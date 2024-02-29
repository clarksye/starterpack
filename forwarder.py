from twisted.internet import reactor, protocol

class ForwarderProtocol(protocol.Protocol):
    def connectionMade(self):
        print("Client connected")
        self.forwarder = protocol.ClientFactory()
        self.forwarder.protocol = ForwarderToPoolProtocol(self)
        reactor.connectTCP("de.pyrin.herominers.com", 1177, self.forwarder)

    def dataReceived(self, data):
        self.forwarder.protocol.transport.write(data)

    def connectionLost(self, reason):
        print("Client disconnected")
        if hasattr(self.forwarder.protocol, 'transport'):
            self.forwarder.protocol.transport.loseConnection()

class ForwarderFactory(protocol.Factory):
    def buildProtocol(self, addr):
        return ForwarderProtocol()

class ForwarderToPoolProtocol(protocol.Protocol):
    def __init__(self, forwarder_protocol):
        self.forwarder_protocol = forwarder_protocol

    def connectionMade(self):
        print("Connected to mining pool")

    def dataReceived(self, data):
        self.forwarder_protocol.transport.write(data)

    def connectionLost(self, reason):
        print("Connection to mining pool lost")

if __name__ == "__main__":
    reactor.listenTCP(80, ForwarderFactory())
    print("Server forwarder listening on port 80")
    reactor.run()
