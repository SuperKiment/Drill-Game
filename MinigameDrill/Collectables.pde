enum CollectableType {
  Pierre, Bois, Or, Argent, Uranium
}

public class Collectable extends Entity {

  private CollectableType type;

  public Collectable() {
    Constructor();
  }

  public Collectable(float x, float y) {
    Constructor();
    pos.set(x, y);
    speed = 0;
  }

  public Collectable(float x, float y, CollectableType t) {
    Constructor();
    pos.set(x, y);
    speed = 0;
    type = t;
  }

  protected void Constructor() {
    super.Constructor();
    isCollectable = true;
    taille.set(50, 50);
    type = CollectableType.Pierre;
  }

  public void Display() {
    push();
    rect(pos.x, pos.y, taille.x, taille.y);
    pop();
  }

  public void setMort() {
    super.setMort();
    finishMiningParticles.addParticles(pos);
  }

  public String getTypeAsString() {
    String res = type.toString();
    return res;
  }
}
