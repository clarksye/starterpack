from twisted.internet import reactor, protocol
from twisted.web.client import Agent
from twisted.web.http_headers import Headers

class ForwarderProtocol(protocol.Protocol):
    def connectionMade(self):
        print("Client connected")
        self.agent = Agent(reactor)
        self.connectToMiningPool()

    def connectToMiningPool(self):
        mining_pool_url = "http://de.pyrin.herominers.com:1177"  # Ganti dengan URL mining pool yang sesuai
        mining_pool_headers = Headers({'User-Agent': ['Twisted Forwarder']})
        self.agent.request(b'GET', mining_pool_url.encode(), mining_pool_headers).addCallback(self.connectedToMiningPool)

    def connectedToMiningPool(self, response):
        print("Connected to mining pool")
        mining_pool_protocol = ForwarderToPoolProtocol(self)
        response.deliverBody(mining_pool_protocol)
        self.mining_pool_protocol = mining_pool_protocol

    def dataReceived(self, data):
        if hasattr(self, 'mining_pool_protocol') and hasattr(self.mining_pool_protocol, 'transport'):
            self.mining_pool_protocol.transport.write(data)

    def connectionLost(self, reason):
        print("Client disconnected")
        if hasattr(self, 'mining_pool_protocol') and hasattr(self.mining_pool_protocol, 'transport'):
            self.mining_pool_protocol.transport.loseConnection()

class ForwarderToPoolProtocol(protocol.Protocol):
    def __init__(self, forwarder_protocol):
        self.forwarder_protocol = forwarder_protocol

    def dataReceived(self, data):
        self.forwarder_protocol.transport.write(data)

    def connectionLost(self, reason):
        print("Connection to mining pool lost")

class ForwarderFactory(protocol.Factory):
    def buildProtocol(self, addr):
        return ForwarderProtocol()

if __name__ == "__main__":
    reactor.listenTCP(80, ForwarderFactory())
    print("Server forwarder listening on port 80")
    reactor.run()
