class Enemy extends Entity {

  Entity cible;

  Enemy(PVector p) {
    Constructor();
    pos = p.copy();
  }

  void Update() {
    UpdateCible();
  }

  void Display() {
    push();
    translate(pos.x, pos.y);
    fill(255, 0, 0);
    rect(0, 0, taille.x, taille.y);
    pop();
  }

  void UpdateCible() {
    Entity proche = null;
    float distProche = 999999999;
    for (Entity e : AllEntities) {
      float testDist = dist(pos.x, pos.y, e.pos.x, e.pos.y);
      if (proche == null || testDist < distProche) {
        proche = e;
        distProche = testDist;
      }
    }
  }
}
