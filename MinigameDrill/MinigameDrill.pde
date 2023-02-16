ArrayList<Entity> AllEntities;
ParticlesManager miningParticles;
ParticlesManager finishMiningParticles;

void setup() {

  size(1000, 1000);
  surface.setTitle("Drill MiniGame");
  surface.setResizable(true);

  miningParticles = new ParticlesManager();
  miningParticles.set(ParticleType.Circle, 5, 2, 0.02, 100, 2);
  miningParticles.setColor(color(#F5B936));

  finishMiningParticles = new ParticlesManager();
  finishMiningParticles.set(ParticleType.Circle, 10, 2, 0.1, 0, 20);
  finishMiningParticles.setColor(color(255));

  camera = new Camera();

  AllEntities = new ArrayList<Entity>();
  AllEntities.add(new Player());

  ui = new UI((Player)AllEntities.get(0));

  AllEntities.add(new Collectable(500, 100, CollectableType.Bois));
  AllEntities.add(new Collectable(500, 250, CollectableType.Pierre));
  AllEntities.add(new Collectable(700, 250, CollectableType.Pierre));
  AllEntities.add(new Collectable(500, 700, CollectableType.Pierre));
  AllEntities.add(new Collectable(200, 800, CollectableType.Pierre));

  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  fill(255);
  noStroke();
}

void draw() {
  background(0);

  camera.Update();
  camera.Translate();

  EntityUpdate();

  EntityDisplay();

  miningParticles.Display();

  finishMiningParticles.Display();

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
