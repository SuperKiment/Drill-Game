import processing.net.*;

Server server;

void setup() {
  server = new Server(this, 5204);
  fill(255);
  size(1000, 800);
  surface.setResizable(true);
  frameRate(10);
}

void draw() {
  background(0);
  while (server.available() != null) {
    Client client = server.available();

    if (client != null) {
      String dataIn = client.readString();
      text(server.clientCount, 20, 20);
      String[][] DataIn = Traitement(dataIn);

      //For tous les clients
      for (int i=0; i<DataIn.length; i++) {
        String[] clientData = DataIn[i];
        text("Client no: "+i, i*200+10, 20);

        //For tous les data
        for (int j=0; j<clientData.length; j++) {
          String data = clientData[j];
          text(data, i*200+20, 20+j*20);
        }
      }
    }
  }
}

String[][] Traitement(String data) {
  ArrayList<String[]> resList = new ArrayList<String[]>();

  String[] Clients = split(data, " | ");

  //Split et arrayList
  for (int i=1; i<Clients.length; i++) {

    String[] Client = split(Clients[i], " / ");
    resList.add(Client);
  }

  //Verifie si l'id existe déjà
  ArrayList<String> ListeIDs = new ArrayList<String>();
  for (int i=0; i<resList.size(); i++) {
    String ID = resList.get(i)[1];

    for (String id : ListeIDs) {
      if (ID.equals(id)) {

        resList.remove(i);
        text("Removed : "+ID, 20, 500);
      } else {
        ListeIDs.add(ID);
      }
    }
  }

  String[][] res;

  res = new String[resList.size()][];

  res = resList.toArray(res);

  if (res.length > 0) text(res[0][0], 20, 510);


  return res;
}
