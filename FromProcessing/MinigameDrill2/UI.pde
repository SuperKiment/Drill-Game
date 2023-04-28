UI ui;

public class UI {
  Player player;
  
  public UI(Player p) {
    player = p;
  }

  public void Display() {
    DisplayMateriaux(player);
  }

  public void DisplayMateriaux(Player player) {

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
}
