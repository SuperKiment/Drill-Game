static Entity getEntityOnPos(ArrayList<Entity> array, float x, float y) {
  for (Entity e : array) {
    if (x > e.pos.x - e.taille.x/2 && x < e.pos.x + e.taille.x/2 &&
      y > e.pos.y - e.taille.y/2 && y < e.pos.y + e.taille.y/2) {
      return e;
    }
  }
  return null;
}



/*

Jeu à deux :

en gros on a chacun un village et on s'attaque mais à travers les villages

*/
