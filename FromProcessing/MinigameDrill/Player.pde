class Player extends Entity {
  private boolean isMoving = false, collecting = false, controllable = true, loaded = false;

  private HashMap<String, Float> Stock;

  private Collectable collectable = null;


  public Player() {
    Constructor();
    controllable = true;
  }

  public Player(String id, boolean c) {
    Constructor();
    controllable = c;
    ID = id;
  }

  protected void Constructor() {
    super.Constructor();

    //Initialise tous les types de collectables dans les keys
    Stock = new HashMap<String, Float>();
    for (int i=0; i<CollectableType.values().length; i++) {
      Stock.put(CollectableType.values()[i].toString(), 0f);
    }

    isPlayer = true;
    speed = 3;
  }

  public void Display() {
    if (ID.equals("52")) {
      println(pos);
    }
    push();
    translate(pos.x, pos.y);
    text(ID, 0, taille.y*2);
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

    if (controllable) {
      if (collect) collecting = Collect();
      else collectable = null;
    } else {
      //Se déplalcer grace au dataIn du serv ?
    }
  }

  //Définit la direction du player
  private void Direction() {
    if (controllable) {
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
    }

    dir.setMag(speed);
  }

  //Fait se déplacer
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

  //Faire la collection du collectable
  private void DoCollect() {
    dir = PVector.sub(collectable.pos.copy(), pos.copy());
    camera.Shake(1);
    miningParticles.addParticles(pos);
    String collectType = collectable.getTypeAsString();
    addStock(collectType, 1);
    collectable.Collected();
  }

  //Ajouter du collectable au hashmap
  private void addStock(String type, float amount) {
    Stock.put(type, Stock.get(type) + amount);
  }

  public void loadData(HashMap<String, String> dataPlayer) {
    if (!loaded) {
      if (dataPlayer.containsKey("posX")) pos.set(float(dataPlayer.get("posX")), float(dataPlayer.get("posY")));
      loaded = true;
    }
    if (dataPlayer.containsKey("dirX")) {
      dir.set(float(dataPlayer.get("dirX")), float(dataPlayer.get("dirY")));
      dir.setMag(1);
    }
    if (dataPlayer.containsKey("tailleX")) taille.set(float(dataPlayer.get("tailleX")), float(dataPlayer.get("tailleY")));
    if (dataPlayer.containsKey("ID")) ID = dataPlayer.get("ID");
    if (dataPlayer.containsKey("isMoving")) {
      isMoving = StringToBoolean(dataPlayer.get("isMoving"));
      println(dir);
    }
  }


  public JSONObject getJSON() {
    JSONObject json = new JSONObject();

    json.setJSONObject("pos", PVectorToJSON(pos));
    json.setJSONObject("taille", PVectorToJSON(taille));
    json.setJSONObject("dir", PVectorToJSON(dir));
    json.setString("class", getClearClass(this));
    json.setString("ID", ID);
    json.setJSONObject("Stock", getStockJSON());

    return json;
  }

  private JSONObject getStockJSON() {
    JSONObject json = new JSONObject();
    println();
    json.setFloat("Bois", Stock.get("Bois"));
    Stock.keySet().forEach((cle) -> {
      json.setFloat(cle,Stock.get(cle));
    }
    );

    return json;
  }
}
