class Player extends Entity {
  private boolean isMoving = false, collecting = false;

  private HashMap<String, Float> Stock;

  private Collectable collectable = null;

  public Player() {
    Constructor();
    speed = 3;
    isPlayer = true;
  }

  protected void Constructor() {
    super.Constructor();

    Stock = new HashMap<String, Float>();
    for (int i=0; i<CollectableType.values().length; i++) {
      Stock.put(CollectableType.values()[i].toString(), 0f);
    }
  }

  public void Display() {
    push();
    translate(pos.x, pos.y);
    rotate(dir.heading());
    rect(0, 0, taille.x, taille.y);
    rect(-taille.x/2, 0, taille.x/2, taille.y/2);
    fill(125);
    ellipse(taille.x/2.5, taille.y/3, 10, 10);
    ellipse(taille.x/2.5, -taille.y/3, 10, 10);
    pop();
  }

  public void Update() {
    Direction();
    Deplacement();
    if (collect) collecting = Collect();
    else collectable = null;
  }

  private void Direction() {
    isMoving = false;
    if (up || right || left || down) {

      isMoving = true;

      if (up) dir.y -= 1;
      if (down) dir.y += 1;
      if (left) dir.x -= 1;
      if (right) dir.x += 1;
    }

    if (collecting && collectable != null) {
      DoCollect();
    }

    dir.setMag(speed);
  }

  private void Deplacement() {
    if (isMoving || collecting) pos.add(dir);
  }

  //Vérifie si on peut bien collecter
  private boolean Collect() {

    Entity interact = Interact(AllEntities);

    if (interact != null && interact.isCollectable) {

      collectable = (Collectable) interact;
      if (collectable != null) {
        return true;
      }
    }

    return false;
  }

  private void DoCollect() {
    dir = PVector.sub(collectable.pos.copy(), pos.copy());
    camera.Shake(1);
    miningParticles.addParticles(pos);
    String collectType = collectable.getTypeAsString();
    addStock(collectType, 1);
    collectable.Collected();
  }

  private void addStock(String type, float amount) {
    Stock.put(type, Stock.get(type) + amount);
  }
}
