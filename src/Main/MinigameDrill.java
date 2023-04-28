package Main;

import processing.core.*;

import Entities.*;

import java.util.*;

public class MinigameDrill extends PApplet {

	public static PGraphics window;
	public static MinigameDrill mgd;
	public static ParticlesManager miningParticles;
	public static ParticlesManager finishMiningParticles;
	public static ParticlesManager mouseParticles;
	public static Camera camera;

	public static final int CENTER = 3;
	public static final int CORNER = 0;

	public static PlayState playState = PlayState.Title;
	public UI ui;

	static ServerManager serverManager;
	SaveManager saveManager;

	public static void main(String[] args) {
		try {
			PApplet.main("Main.MinigameDrill");
		} catch (Exception e) {
			System.out.print(e);
		}
	}

	public void settings() {
		size(1000, 1000);
		// fullScreen();
	}

	public void setup() {
		window = this.g;
		mgd = this;

		surface.setTitle("Drill MiniGame");
		surface.setResizable(true);

		Entity.minigameDrill = this;
		Entity.AllEntities = new ArrayList<Entity>();

		serverManager = new ServerManager(this, ServerManager.NetType.Server, "192.168.43.85");

		miningParticles = new ParticlesManager();
		finishMiningParticles = new ParticlesManager();
		mouseParticles = new ParticlesManager();
		
		// Particules de minage miningParticles = new ParticlesManager();
		miningParticles.set(ParticleType.Circle, 5, 2, 0.02f, 100, 2);
		miningParticles.setColor(245, 185, 54);

		// Particules de fin de minage finishMiningParticles = new ParticlesManager();
		finishMiningParticles.set(ParticleType.Circle, 10, 2, 0.1f, 0, 20);
		finishMiningParticles.setColor(255, 255, 255);

		// Particules de souris mouseParticles = new ParticlesManager();
		mouseParticles.set(ParticleType.Circle, 2, 1, 0.1f, 5, 1);
		mouseParticles.setColor(255, 255, 255);

		camera = new Camera();

		// Ajout de player aux entit�s Entity.AllEntities = new ArrayList<Entity>();
		Entity.AllEntities.add(new Player());
		Entity.AllEntities.add(new Player("5412", false));

		ui = new UI((Player) Entity.AllEntities.get(0));

		// Ajout de plusieurs collectables
		Entity.AllEntities.add(new Collectable(500, 100, Collectable.CollectableType.Bois));
		Entity.AllEntities.add(new Collectable(500, 250, Collectable.CollectableType.Pierre));
		Entity.AllEntities.add(new Collectable(700, 250, Collectable.CollectableType.Pierre));
		Entity.AllEntities.add(new Collectable(500, 700, Collectable.CollectableType.Or));
		Entity.AllEntities.add(new Collectable(200, 800, Collectable.CollectableType.Pierre));

		Entity.AllEntities.add(new Enemy(new PVector(100, 500)));

		saveManager = new SaveManager();

		// Base styles d'affichage rectMode(CENTER); textAlign(CENTER, CENTER);
		fill(255);
		noStroke();

		// saveManager.Save("map1"); //saveManager.LoadData("map1");

	}

	public void draw() {

		background(0);

		if (playState == PlayState.Play) {

			if (serverManager != null)
				serverManager.PreUpdate();

			camera.Update();
			camera.Translate();

			// Update et Display et toutes les entit�s Entity.EntityUpdate();
			Entity.EntityDisplay();
		}

		if (playState == PlayState.Title && mousePressed)
			mouseParticles.addParticles(50, new PVector(mouseX, mouseY));

		// Update et Display et toutes les particules miningParticles.Display();
		finishMiningParticles.Display();
		mouseParticles.Display();

		ui.Display();

		// Entity.PrintArray();

		serverManager.PostUpdate();

	}

	static public boolean up, down, right, left, collect;

	public void keyPressed() {
		if (key == 'z')
			up = true;
		if (key == 'q')
			left = true;
		if (key == 's')
			down = true;
		if (key == 'd')
			right = true;
		if (key == 'e')
			collect = true;
	}

	public void keyReleased() {
		if (key == 'z')
			up = false;
		if (key == 'q')
			left = false;
		if (key == 's')
			down = false;
		if (key == 'd')
			right = false;
		if (key == 'e')
			collect = false;
	}

	public enum PlayState {
		Title, Play
	}
}