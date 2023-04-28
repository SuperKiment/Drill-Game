package Main;

import processing.core.*;

import java.awt.Color;
import java.util.*;

public class ParticlesManager {

	private boolean stroke = false;
	private Color col = new Color(255, 255, 255);
	private float taille = 5, vel = 1, timeLimit = 1000, damp = 0.1f;
	private int nb = 5;
	private ParticleType type = ParticleType.Circle;

	private ArrayList<Particles> AllParticles;

	public ParticlesManager() {
		AllParticles = new ArrayList<Particles>();
	}

	public void Display() {
		MinigameDrill.window.push();
		if (stroke)
			MinigameDrill.window.stroke(0);
		MinigameDrill.window.fill(col.getRGB());
		for (int i = 0; i < AllParticles.size(); i++) {
			Particles p = AllParticles.get(i);

			p.Display();

			if (p.mort)
				AllParticles.remove(i);
		}

		MinigameDrill.window.pop();
	}

	// Ajoute un paquet de particules (inutilis�) custom
	public void addParticles(int puissance, PVector p) {
		AllParticles.add(new Particles(puissance, p));
	}

	// Ajoute un paquet de particules aux coord
	public void addParticles(PVector p) {
		/*
		 * Type de forme Taille Position Vitesse Ralentissement (damp) Limite de temps
		 * (si sp�cifi�, autrement disparait par manque de vitesse) / 0 Nombre de
		 * Particle
		 */
		AllParticles.add(new Particles(type, taille, p, vel, damp, timeLimit, nb));
	}

	public void setStroke(boolean s) {
		stroke = s;
	}

	public void setColor(Color c) {
		col = c;
	}
	
	public void setColor(int r, int g, int b) {
		col = new Color(r, g, b);
	}

	public void setTaille(float t) {
		taille = t;
	}

	public void setDamp(float t) {
		damp = t;
	}

	public void setVel(float t) {
		vel = t;
	}

	public void setTimeLimit(float t) {
		timeLimit = t;
	}

	public void setNb(int t) {
		nb = t;
	}

	public void setShapeType(ParticleType p) {
		type = p;
	}

	/*
	 * Type de forme Taille Vitesse Ralentissement (damp) Limite de temps (si
	 * sp�cifi�, autrement disparait par manque de vitesse) / 0 Nombre de Particle
	 */
	public void set(ParticleType t, float ta, float bV, float d, float tL, int nb) {
		type = t;
		taille = ta;
		vel = bV;
		damp = d;
		timeLimit = tL;
		this.nb = nb;
	}
	// ============================================================

	// Paquet de particules
	private class Particles {
		private ArrayList<Particle> AllParticles;
		private PVector pos;
		private boolean mort = false;

		public Particles(int puissance, PVector p) {

			pos = p.copy();
			AllParticles = new ArrayList<Particle>();

			for (int i = 0; i < puissance; i++) {
				AllParticles.add(new Particle(
						// type
						ParticleType.Circle,
						// taille
						10,
						// pos
						pos.copy(),
						// vel
						puissance / 5,
						// ralentissement
						0.1f
				));
			}
		}

		/*
		 * Type de forme Taille Position Vitesse Ralentissement (damp) Limite de temps
		 * (si sp�cifi�, autrement disparait par manque de vitesse) / 0 Nombre de
		 * Particle
		 */
		public Particles(ParticleType t, float ta, PVector p, float bV, float d, float tL, int nb) {

			pos = p.copy();
			AllParticles = new ArrayList<Particle>();

			if (tL == 0) {
				for (int i = 0; i < nb; i++) {
					AllParticles.add(new Particle(

							// type
							ParticleType.Circle,
							// taille
							ta,
							// pos
							p.copy(),
							// vel
							bV,
							// ralentissement
							d));
				}
			} else {
				for (int i = 0; i < nb; i++) {
					AllParticles.add(new Particle(

							// type
							ParticleType.Circle,
							// taille
							ta,
							// pos
							p.copy(),
							// vel
							bV,
							// ralentissement
							d,
							// Time limit
							tL));
				}
			}
		}

		public void Display() {
			if (AllParticles.isEmpty()) {
				mort = true;
			}

			for (int i = 0; i < AllParticles.size(); i++) {
				Particle p = AllParticles.get(i);
				p.Update();
				p.Display();

				if (p.isMort)
					AllParticles.remove(i);
			}
		}

		// ============================================================

		// Une particule
		private class Particle {

			private ParticleType type;
			private PVector pos, ori;
			private float taille, vel, damp, timer, timeLimit = 0;
			private boolean isMort = false, isTimed = false;
			private Random r;
			/*
			 * Type de forme Taille Position Vitesse Ralentissement (damp) Limite de temps
			 * (si sp�cifi�, autrement disparait par manque de vitesse)
			 */

			public Particle(ParticleType t, float ta, PVector p, float bV, float d, float tL) {
				r = new Random();
				
				type = t;
				taille = ta;
				pos = p.copy();

				vel = r.nextFloat(bV / 2, bV * 2);

				ori = PVector.random2D();
				ori.setMag(1);

				damp = r.nextFloat(d / 10, d);

				timer = MinigameDrill.mgd.millis();
				timeLimit = r.nextFloat(tL / 2, tL * 2);
				isTimed = true;
			}

			public Particle(ParticleType t, float ta, PVector p, float bV, float d) {
				r = new Random();

				type = t;
				taille = ta;
				pos = p.copy();

				vel = r.nextFloat(bV / 2, bV * 2);

				ori = PVector.random2D();
				ori.setMag(1);

				damp = r.nextFloat(d / 10, d);

				isTimed = false;
			}

			public void Update() {
				vel = MinigameDrill.lerp(vel, 0, damp);
				ori.setMag(vel);

				pos.add(ori);

				// Soit il est tim� soit il disparait quand il a plus de vitesse
				if (!isTimed) {
					if (vel < 0.1)
						isMort = true;
				} else {
					if (MinigameDrill.mgd.millis() - timer > timeLimit)
						isMort = true;
				}
			}

			public void Display() {
				MinigameDrill.window.push();

				MinigameDrill.window.translate(pos.x, pos.y);

				MinigameDrill.window.rectMode(MinigameDrill.CENTER);

				MinigameDrill.window.strokeWeight(2);

				switch (type) {

				case Square:
					MinigameDrill.window.rect(0, 0, taille, taille);
					break;

				case Circle:
					MinigameDrill.window.ellipse(0, 0, taille, taille);
					break;
				}

				MinigameDrill.window.pop();
			}
		}
	}
}

enum ParticleType {
	Square, Circle
}