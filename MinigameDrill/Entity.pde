enum EntityType { //<>//
  Collectable, Mob, Interactable, Player
}

//=====================================

static class Entity {

  static ArrayList<Entity> AllEntities;
  static MinigameDrill minigameDrill;

  protected BarreHP barreHP;

  protected PVector pos, taille, dir;
  protected boolean mort = false;
  protected float speed = 1, HP = 100, baseHP = 100, collectMinTaille = 20;

  public String ID = "";

  public boolean
    isCollectable = false,
    isPlayer = false,
    isInteractable = false;

  public Entity() {
    Constructor();
  }

  //Constructor de base
  protected void Constructor() {
    ID = String.valueOf(AllEntities.size());
    pos = new PVector(200, 200);
    taille = new PVector(10, 10);
    dir = new PVector(1, 0);
    HP = baseHP;
  }

  public void Update() {
  }

  public void Display() {
  }

  //Retourne une entité en cas d'interaction avec une entité
  public Entity Interact(ArrayList<Entity> array) {
    PVector testPos = pos.copy();
    PVector testDir = dir.copy();

    testDir.setMag(taille.x);
    testPos.add(testDir);

    Entity e = getEntityOnPos(array, testPos.x, testPos.y);
    return e;
  }

  //Appelé quand le collectable est en train de se faire collecter
  protected void Collected() {
    taille.sub(new PVector(1, 1));
    if (taille.x < collectMinTaille || taille.y < collectMinTaille) setMort();
  }

  public void setMort() {
    mort = true;
  }

  protected void loadData(HashMap<String, String> dataPlayer) {
    if (dataPlayer.containsKey("posX")) pos.set(float(dataPlayer.get("posX")), float(dataPlayer.get("posY")));
    if (dataPlayer.containsKey("dirX")) dir.set(float(dataPlayer.get("dirX")), float(dataPlayer.get("dirY")));
    if (dataPlayer.containsKey("tailleX")) taille.set(float(dataPlayer.get("tailleX")), float(dataPlayer.get("tailleY")));
    if (dataPlayer.containsKey("ID")) ID = dataPlayer.get("ID");
  }

  public JSONObject getJSON() {
    JSONObject json = new JSONObject();

    json.setJSONObject("pos", PVectorToJSON(pos));
    json.setJSONObject("taille", PVectorToJSON(taille));
    json.setJSONObject("dir", PVectorToJSON(dir));
    json.setString("class", getClearClass(this));
    json.setString("ID", ID);

    return json;
  }

  public String getNetInfo() {
    String dataOut = "";
    String separPlayer = ServerManager.separPlayer;
    String separData = ServerManager.separData;
    dataOut += separPlayer;

    dataOut += ToWriteClient("posX") + pos.x + ToWriteClient("posY") + pos.y + ToWriteClient("ID") + ID + ToWriteClient("class") + getClearClass(this);

    return dataOut;
  }

  //=====================
  //========================================STATIC
  //=====================

  //Update toutes les entités
  public static void EntityUpdate() {
    for (int i=0; i<AllEntities.size(); i++) {
      Entity e = AllEntities.get(i);

      e.Update();

      CollisionEntity(AllEntities, e);

      if (e.mort) {
        AllEntities.remove(i);
      }
    }
  }

  //Affiche toutes les entités
  public static void EntityDisplay() {
    for (int i=0; i<AllEntities.size(); i++) {
      Entity e = AllEntities.get(i);

      e.Display();
    }
  }

  //Teste les collisions avec d'autres entités
  public static void CollisionEntity(ArrayList<Entity> array, Entity me) {
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
  private static boolean CollisionOk(Entity me, Entity e) {
    if (me.pos.x - me.taille.x/2 < e.pos.x + e.taille.x/2 && me.pos.x + me.taille.x/2 > e.pos.x - e.taille.x/2 &&
      me.pos.y - me.taille.y/2 < e.pos.y + e.taille.y/2 && me.pos.y + me.taille.y/2 > e.pos.y - e.taille.y/2) {
      return true;
    }
    return false;
  }

  private static PVector DirectionCollision(Entity me, Entity e) {
    PVector dir = PVector.sub(me.pos, e.pos);

    if (abs(dir.x) > abs(dir.y)) {
      dir.set(dir.x, 0);
    } else {
      dir.set(0, dir.y);
    }

    dir.setMag(1);

    return dir;
  }

  public static void AddEntityFromServer(HashMap<String, String> hash) {
    //Si il y a une class spécifiée dans le hash
    if (hash.containsKey("class")) {
      switch(hash.get("class")) {
      case "Collectable":
        //Nouveau collectable qu'on ajoute
        Collectable c = minigameDrill.new Collectable();
        c.loadData(hash);
        c.type = CollectableType.valueOf(hash.get("type"));
        println(AllEntities.size());
        AllEntities.add(c);
        break;
      case "Player":
        //Nouveau Player
        Player p = minigameDrill.new Player(hash.get("ID"));
        p.loadData(hash);
        AllEntities.add(p);
        break;

      default:
        println("Pas de classe trouvée pour :", hash);
        break;
      }
    } else {
      println("Pas de spécification de classe : "+hash);
    }
  }

  public static void PrintArray() {
    println("Entities :");
    for (Entity e : AllEntities) {
      print("    ");
      print("ID:"+e.ID);
      print(" / Class:"+split(e.getClass().toString(), '$')[1]);
      println();
    }
  }

  public static JSONArray getAllEntitiesJSON() {
    JSONArray array = new JSONArray();

    for (int i=0; i<AllEntities.size(); i++) {
      Entity e = AllEntities.get(i);
      array.setJSONObject(i, e.getJSON());
    }

    return array;
  }

  public static void loadFromJSON(JSONArray json) {
    AllEntities.clear();

    for (int i=0; i<json.size(); i++) {
      JSONObject e = json.getJSONObject(i);
    }
  }

  public static void add(JSONObject json) {
    try {
      //On doit pouvoir récup le nom de la class et de l'instancier ici
      Class c = Class.forName("Player");
    }
    catch (Exception e) {
    }
    switch(json.getString("class")) {
    case "Player":
      Player p = minigameDrill.new Player(json.getString("ID"));
      AllEntities.add(p);
      break;
    }
  }
}

//======================================================

public class BarreHP {

  private float HP, baseHP;

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
