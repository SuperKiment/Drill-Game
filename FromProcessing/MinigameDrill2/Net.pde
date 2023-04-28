enum NetType {
  Client, Server
}

class ServerManager {

  String ID;

  Client client;
  Server server;
  NetType type;

  ServerManager(MinigameDrill2 proc, NetType t) {
    ID = Integer.toString(int(random(10000, 99999)));

    type = t;

    switch (t) {
    case Client:
      client = new Client(proc, "127.0.0.1", 5204);
      client.write(ToWrite("ID")+ID);
      break;
    case Server:
      server = new Server(proc, 5204);
      break;
    }
  }

  void Update() {
    if (type == NetType.Server) {
      server.write("ytestetstes salut");
    } else if (type == NetType.Client) {
      client.write(" | "+ToWrite("ID")+ID);
    }
  }

  String ToWrite(String w) {
    return " / "+w+":";
  }
}
