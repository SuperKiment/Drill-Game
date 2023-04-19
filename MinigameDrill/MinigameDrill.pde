import processing.net.*;

ParticlesManager miningParticles;
ParticlesManager finishMiningParticles;
ParticlesManager mouseParticles;

PlayState playState = PlayState.Title;

ServerManager serverManager;

void setup() {

  fullScreen();
  //size(1000, 1000);
  surface.setTitle("Drill MiniGame");
  surface.setResizable(true);
  Entity.minigameDrill = this;

  serverManager = new ServerManager(this, NetType.Client, "127.0.0.1");

  //Particules de minage
  miningParticles = new ParticlesManager();
  miningParticles.set(ParticleType.Circle, 5, 2, 0.02, 100, 2);
  miningParticles.setColor(color(#F5B936));

  //Particules de fin de minage
  finishMiningParticles = new ParticlesManager();
  finishMiningParticles.set(ParticleType.Circle, 10, 2, 0.1, 0, 20);
  finishMiningParticles.setColor(color(255));

  //Particules de souris
  mouseParticles = new ParticlesManager();
  mouseParticles.set(ParticleType.Circle, 2, 1, 0.1, 5, 1);
  mouseParticles.setColor(color(255));

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

  if (playState == PlayState.Play) {

    if (serverManager != null) serverManager.Update();

    camera.Update();
    camera.Translate();

    //Update et Display et toutes les entités
    Entity.EntityUpdate();
    Entity.EntityDisplay();
  }

  if (playState == PlayState.Title && mousePressed)
    mouseParticles.addParticles(50, new PVector(mouseX, mouseY));

  //Update et Display et toutes les particules
  miningParticles.Display();
  finishMiningParticles.Display();
  mouseParticles.Display();

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

void mousePressed() {
}

enum PlayState {
  Title, Play
}
