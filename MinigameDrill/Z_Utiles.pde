static Entity getEntityOnPos(ArrayList<Entity> array, float x, float y) {
  for (Entity e : array) {
    if (x > e.pos.x - e.taille.x/2 && x < e.pos.x + e.taille.x/2 &&
      y > e.pos.y - e.taille.y/2 && y < e.pos.y + e.taille.y/2) {
      return e;
    }
  }
  return null;
}

static boolean StringToBoolean(String s) {
  if (s.equals("true")) return true;
  else if (s.equals("false")) return false;
  else if (s.equals("0")) return false;
  else if (s.equals("1")) return true;
  return false;
}

static String BooleanToNumString(boolean b) {
  return b ? "1" : "0";
}


/*

 Jeu à deux :
 
 en gros on a chacun un village et on s'attaque mais à travers les villages
 
 Objectifs actuels :
 Standardiser l'envoi de données par un buffer
 Ajouter les villages (duh)
 
 
 */
