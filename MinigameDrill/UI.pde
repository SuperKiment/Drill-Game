UI ui;

public class UI {
  Player player;
  ArrayList<Bouton> AllBoutons;

  public UI(Player p) {
    player = p;
    AllBoutons = new ArrayList<Bouton>();
    SetAllBoutons();
  }

  public void Display() {
    if (playState == PlayState.Play) {
      DisplayMateriaux(player);
    }
    DisplayNet(serverManager);
    DisplayBoutons();
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
    try {
      rectMode(CORNER);
      fill(255, 255, 255, 50);
      rect(0, 0, 150, 50);
      fill(255);
      textAlign(LEFT);
      textSize(10);
      if (s.type == NetType.Server) {
        text("Server", 20, 20);
        text("IP : "+Server.ip(), 20, 30);
        //text("Clients connectés : "+s.server.clientCount, 20, 40);
      } else {
        text("Client", 20, 20);
        text("Connecté : "+s.client.ip(), 20, 30);
      }
    }
    catch (Exception e) {
      println("oopsi doopsi");
    }
    pop();
  }

  private void DisplayBoutons() {
    for (Bouton b : AllBoutons) {
      if (playState.toString().equals(b.route)) {
        push();
        StyleBoutons();
        b.Update();
        pop();
      }
    }
  }

  public void SetAllBoutons() {
    //Bouton titre
    AllBoutons.add(new Bouton(width/2, height/2, 500, 200, "Title", "Play !") {
      public void Action() {
        playState = PlayState.Play;
      }
    }
    );

    //Bouton changement server/client
    AllBoutons.add(new Bouton(width/2, height*3/4, 500, 100, "Title", "Vous êtes : "+serverManager.type.toString()) {
      public void Action() {
        if (serverManager.type == NetType.Server) {
          serverManager.type = NetType.Client;
          serverManager.UpdateInstance();
        } else {
          serverManager.type = NetType.Server;
        }

        this.texte = "Vous êtes : "+serverManager.type.toString();
      }
    }
    );
  }
}

public class Bouton {
  private PVector pos, taille;
  public String route, texte;
  private boolean clicked = false, lastState = false;

  public Bouton(float x, float y, float tx, float ty, String r, String t) {
    pos = new PVector(x, y);
    taille = new PVector(tx, ty);
    route = r;
    texte = t;
  }

  public void Update() {
    if (mouseX > pos.x-taille.x/2 && mouseX < pos.x+taille.x/2
      &&mouseY > pos.y-taille.y/2 && mouseY < pos.y+taille.y/2) {
      clicked = false;
      fill(50);
      strokeWeight(3);
      if (mousePressed) {
        fill(100);
        clicked = true;
      }
      if (!clicked && lastState) Action();
      lastState = clicked;
    }
    rect(pos.x, pos.y, taille.x, taille.y);
    fill(255);
    text(texte, pos.x, pos.y);
  }

  public void Action() {
    println("Bouton pressé :", route, texte);
  }
}

public void StyleBoutons() {
  fill(0);
  stroke(255);
  strokeWeight(1);
  textAlign(CENTER);
  textSize(50);
  rectMode(CENTER);
}
