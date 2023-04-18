import processing.net.*;

ParticlesManager miningParticles;
ParticlesManager finishMiningParticles;

PlayState playState = PlayState.Title;

ServerManager serverManager;

void setup() {

  Entity.minigameDrill = this;

  serverManager = new ServerManager(this, NetType.Client, "127.0.0.1");

  size(1000, 1000);
  surface.setTitle("Drill MiniGame");
  surface.setResizable(true);

  //Particules de minage
  miningParticles = new ParticlesManager();
  miningParticles.set(ParticleType.Circle, 5, 2, 0.02, 100, 2);
  miningParticles.setColor(color(#F5B936));

  //Particules de fin de minage
  finishMiningParticles = new ParticlesManager();
  finishMiningParticles.set(ParticleType.Circle, 10, 2, 0.1, 0, 20);
  finishMiningParticles.setColor(color(255));

  camera = new Camera();

  //Ajout de player aux entités
  Entity.AllEntities = new ArrayList<Entity>();
  Entity.AllEntities.add(new Player());
  Entity.AllEntities.add(new Player("5412"));

  ui = new UI((Player)Entity.AllEntities.get(0));

  //Ajout de plusieurs collectables
  Entity.AllEntities.add(new Collectable(500, 100, CollectableType.Bois));
  Entity.AllEntities.add(new Collectable(500, 250, CollectableType.Pierre));
  Entity.AllEntities.add(new Collectable(700, 250, CollectableType.Pierre));
  Entity.AllEntities.add(new Collectable(500, 700, CollectableType.Pierre));
  Entity.AllEntities.add(new Collectable(200, 800, CollectableType.Pierre));

  Entity.AllEntities.add(new Enemy(new PVector(100, 500)));

  //Base styles d'affichage
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  fill(255);
  noStroke();
}

void draw() {
  background(0);

  if (serverManager != null) serverManager.Update();

  if (playState == PlayState.Play) {
    camera.Update();
    camera.Translate();

    //Update et Display et toutes les entités
    Entity.EntityUpdate();
    Entity.EntityDisplay();

    //Update et Display et toutes les particules
    miningParticles.Display();
    finishMiningParticles.Display();
  }
  ui.Display();
}

boolean up, down, right, left, collect;

void keyPressed() {
  if  (key == 'z') up = true;
  if  (key == 'q') left = true;
  if  (key == 's') down = true;
  if  (key == 'd') right = true;
  if  (key == 'e') collect = true;
}

void keyReleased() {
  if  (key == 'z') up = false;
  if  (key == 'q') left = false;
  if  (key == 's') down = false;
  if  (key == 'd') right = false;
  if  (key == 'e') collect = false;
}

enum PlayState {
  Title, Play
}
