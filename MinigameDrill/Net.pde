enum NetType {
  Client, Server
}

class ServerManager {

  public String ID;

  private Client client;
  private Server server;
  public NetType type;
  public int port = 5204;

  private String separPlayer = " | ", separData = " / ";

  float timerReconnexion = 0, cooldownReconnexion = 1000;

  ArrayList<String> EnvoiBuffer;
  HashMap<String, HashMap<String, String>> DataIn;

  MinigameDrill minigameDrill;
  String ipClient;


  ServerManager(MinigameDrill proc, NetType t, String ip) {

    minigameDrill = proc;
    ipClient = ip;

    DataIn = new HashMap<String, HashMap<String, String>>();

    //Init un ID random
    ID = Float.toString(int(random(1000, 9999)));
    EnvoiBuffer = new ArrayList<String>();
    type = t;

    switch (t) {
    case Client:
      client = new Client(proc, ip, port);
      client.write(ToWriteClient("ID")+ID);
      break;
    case Server:
      server = new Server(proc, port);
      break;
    }
  }


  public void Update() {
    EnvoiBuffer.clear();
    if (type == NetType.Server) {
      //SERVER
      if (server != null) {
        //Récup et traitement des données
        server.write("ytestetstes salut");
      } else server = new Server(minigameDrill, port);
    } else if (type == NetType.Client) {
      //CLIENT
      if (client != null) {
        //Si on est connectés, envoyer les données. Sinon se reconnecter
        if (client.ip() != null) {
          //Récup des données
          String read = client.readString();
          println(read);
          if (read != null && read != "") {
            DataIn = StringToHashClient(read);
            traiterDonnees();
          }

          //Envoi des données
          client.write(separPlayer+ToWriteClient("ID")+ID+ToWriteClient("coucou"));
        } else {
          if (millis() - timerReconnexion > cooldownReconnexion) {
            timerReconnexion = millis();
            client = new Client(minigameDrill, ipClient, port);
          }
        }
      }
    }
  }


  //Division du String en HashMap
  public HashMap<String, HashMap<String, String>> StringToHashClient(String base) {
    HashMap<String, HashMap<String, String>> res = new HashMap<String, HashMap<String, String>>();

    String[] dataIn = split(base, separPlayer);

    //Division des |
    for (String dataPlayer : dataIn) {
      HashMap<String, String> playerData = new HashMap<String, String>();

      if (dataPlayer != "") {
        String[] datas = split(dataPlayer, separData);

        //Division des /
        for (String data : datas) {
          if (data != "") {
            try {
              String[] fragment = split(data, ':');
              playerData.put(fragment[0], fragment[1]);
            }
            catch (Exception e) {
              println("Erreur sur : "+data);
            }
          }
        }
      }

      res.put(playerData.get("ID"), playerData);
    }

    res.remove(null);

    return res;
  }


  //Traitement des données
  private void traiterDonnees() {
    ArrayList<String> AllIDs = new ArrayList<String>();
    for (Entity e : Entity.AllEntities) {
      AllIDs.add(e.ID);
    }

    for (String id : DataIn.keySet()) {
      if (!AllIDs.contains(id)) {
        Entity.AddEntityFromServer(DataIn.get(id));
      } else {
        for (Entity e : Entity.AllEntities) {
          if (e.ID.equals(id)) {
            e.loadData(DataIn.get(id));
          }
        }
      }
    }
  }

  public void AddEnvoi(String envoi) {
    EnvoiBuffer.add(envoi);
  }

  public void UpdateInstance() {
    if (type == NetType.Client) {
      client = new Client(minigameDrill, ipClient, port);
    } else {
      server = new Server(minigameDrill, port);
    }
  }
}


public static String ToWriteClient(String w) {
  return " / "+w+":";
}
