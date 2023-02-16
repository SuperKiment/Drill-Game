static Entity getEntityOnPos(ArrayList<Entity> array, float x, float y) {
  for (Entity e : array) {
    if (x > e.pos.x - e.taille.x/2 && x < e.pos.x + e.taille.x/2 &&
      y > e.pos.y - e.taille.y/2 && y < e.pos.y + e.taille.y/2) {
      return e;
    }
  }
  return null;
}


void CollisionEntity(Entity me) {
  try {
    for (Entity e : AllEntities) {

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
boolean CollisionOk(Entity me, Entity e) {
  if (me.pos.x - me.taille.x/2 < e.pos.x + e.taille.x/2 && me.pos.x + me.taille.x/2 > e.pos.x - e.taille.x/2 &&
    me.pos.y - me.taille.y/2 < e.pos.y + e.taille.y/2 && me.pos.y + me.taille.y/2 > e.pos.y - e.taille.y/2) {
    return true;
  }
  return false;
}

PVector DirectionCollision(Entity me, Entity e) {
  PVector dir = PVector.sub(me.pos.copy(), e.pos.copy());

  if (abs(dir.x) > abs(dir.y)) {
    dir.set(dir.x, 0);
  } else {
    dir.set(0, dir.y);
  }

  dir.setMag(1);

  return dir;
}
