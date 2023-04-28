enum EntityType {
  Collectable, Mob, Interactable, Player
}

//=====================================

static class Entity {

  static ArrayList<Entity> AllEntities;

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

  //========================================STATIC

  static void EntityUpdate() {
    for (int i=0; i<AllEntities.size(); i++) {
      Entity e = AllEntities.get(i);

      e.Update();

      CollisionEntity(AllEntities, e);

      if (e.mort) {
        AllEntities.remove(i);
      }
    }
  }

  static void EntityDisplay() {
    for (int i=0; i<AllEntities.size(); i++) {
      Entity e = AllEntities.get(i);

      e.Display();
    }
  }

  static void CollisionEntity(ArrayList<Entity> array, Entity me) {
    try {
      for (Entity e : array) {

        //Ajout de collision
        if (e != me) {
          if (CollisionOk(me, e)) {

            //println("collision "+frameRate+" / "+e.getClass()+" : "+me.getClass());
            PVector dir = DirectionCollision(me, e);
            float mag = 0;
            if (abs(dir.x) > 0) {
              mag = -(abs((me.pos.x-e.pos.x)) - (me.taille.x + e.taille.x)/2);
            } else {
              mag = -(abs((me.pos.y-e.pos.y)) - (me.taille.y + e.taille.y)/2);
            }
            dir.setMag(mag);
            me.pos.add(dir);
          }
          /*
        PVector colOri = new PVector(pos.x - e.pos.x, pos.y - e.pos.y);
           float mag = -(d - (taille + e.taille.x)/2);
           colOri.setMag(mag);
           pos.add(colOri);
           */
        }
      }
    }
    catch (Exception e) {
      println("Collision fail");
    }
  }


  //Vérifie s'il y a collision
  static boolean CollisionOk(Entity me, Entity e) {
    if (me.pos.x - me.taille.x/2 < e.pos.x + e.taille.x/2 && me.pos.x + me.taille.x/2 > e.pos.x - e.taille.x/2 &&
      me.pos.y - me.taille.y/2 < e.pos.y + e.taille.y/2 && me.pos.y + me.taille.y/2 > e.pos.y - e.taille.y/2) {
      return true;
    }
    return false;
  }

  static PVector DirectionCollision(Entity me, Entity e) {
    PVector dir = PVector.sub(me.pos.copy(), e.pos.copy());

    if (abs(dir.x) > abs(dir.y)) {
      dir.set(dir.x, 0);
    } else {
      dir.set(0, dir.y);
    }

    dir.setMag(1);

    return dir;
  }
}

//======================================================

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
