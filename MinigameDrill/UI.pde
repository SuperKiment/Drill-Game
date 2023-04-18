UI ui;

public class UI {
  Player player;

  public UI(Player p) {
    player = p;
  }

  public void Display() {
    DisplayMateriaux(player);
    DisplayNet(serverManager);
  }

  private void DisplayMateriaux(Player player) {

    push();
    rectMode(CORNERS);
    fill(255, 225, 255, 20);
    rect(width*4/5, 0, width, height/2);
    pop();

    int nbTypes = CollectableType.values().length;
    for (int i=0; i<CollectableType.values().length; i++) {
      push();
      fill(255);
      textSize(20);
      textAlign(LEFT);

      text(CollectableType.values()[i].toString(), width*4.1/5, (i+0.5)*(height/2)/nbTypes);
      text(player.Stock.get(CollectableType.values()[i].toString()), width*4.7/5, (i+0.5)*(height/2)/nbTypes);

      pop();
    }
  }

  private void DisplayNet(ServerManager s) {
    push();
    rectMode(CORNER);
    fill(255, 255, 255, 50);
    rect(0, 0, 150, 50);
    fill(255);
    textAlign(LEFT);
    textSize(10);
    if (s.type == NetType.Server) {
      text("Server", 20, 20);
      text("IP : "+Server.ip(), 20, 30);
      text("Clients connectés : "+s.server.clientCount, 20, 40);
    } else {
      text("Client", 20, 20);
      text("Connecté : "+s.client.ip(), 20, 30);
    }
    pop();
  }
}

public class Bouton {
  Bouton() {
  }
}
