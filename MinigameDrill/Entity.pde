enum EntityType {
  Collectable, Mob, Interactable, Player
}

//=====================================

static class Entity {

  protected BarreHP barreHP;

  protected PVector pos, taille, dir;
  protected boolean mort = false;
  protected float speed = 1, HP = 100, baseHP = 100, collectMinTaille = 20;

  public boolean
    isCollectable = false,
    isPlayer = false,
    isInteractable = false;

  public Entity() {
    Constructor();
  }

  protected void Constructor() {
    pos = new PVector(200, 200);
    taille = new PVector(10, 10);
    dir = new PVector(1, 0);
    HP = baseHP;
  }

  public void Update() {
  }

  public void Display() {
  }

  public Entity Interact(ArrayList<Entity> array) {
    PVector testPos = pos.copy();
    PVector testDir = dir.copy();

    testDir.setMag(taille.x);
    testPos.add(testDir);

    Entity e = getEntityOnPos(array, testPos.x, testPos.y);
    return e;
  }

  protected void Collected() {
    taille.sub(new PVector(1, 1));
    if (taille.x < collectMinTaille || taille.y < collectMinTaille) setMort();
  }

  public void setMort() {
    mort = true;
  }
}

//======================================================

void EntityUpdate() {
  for (int i=0; i<AllEntities.size(); i++) {
    Entity e = AllEntities.get(i);

    e.Update();

    CollisionEntity(e);

    if (e.mort) {
      AllEntities.remove(i);
    }
  }
}

void EntityDisplay() {
  for (int i=0; i<AllEntities.size(); i++) {
    Entity e = AllEntities.get(i);

    e.Display();
  }
}

class BarreHP {

  float HP, baseHP;

  BarreHP(float bhp) {
    baseHP = bhp;
    HP = baseHP;
  }

  void Display(float hp) {
    HP = hp;

    push();

    fill(50);
    rect(0, 0, hp, 20);

    fill(255, 0, 0);
    rect(0, 0, hp-2, 20-2);

    pop();
  }
}
