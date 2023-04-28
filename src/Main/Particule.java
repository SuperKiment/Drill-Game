package Main;

import processing.core.*;
import java.util.*;

public class ParticlesManager {

	private boolean stroke = false;
	private color col = color(255, 255, 255);
	private float taille = 5, vel = 1, timeLimit = 1000, damp = 0.1;
	private int nb = 5;
	private ParticleType type = ParticleType.Circle;

	private ArrayList<Particles> AllParticles;

	public ParticlesManager() {
		AllParticles = new ArrayList<Particles>();
	}

	public void Display() {
		push();
		if (stroke)
			stroke(0);
		fill(col);
		for (int i = 0; i < AllParticles.size(); i++) {
			Particles p = AllParticles.get(i);

			p.Display();

			if (p.mort)
				AllParticles.remove(i);
		}

		pop();
	}

	// Ajoute un paquet de particules (inutilisé) custom
	public void addParticles(int puissance, PVector p) {
		AllParticles.add(new Particles(puissance, p));
	}

	// Ajoute un paquet de particules aux coord
	public void addParticles(PVector p) {
		/*
		 * Type de forme Taille Position Vitesse Ralentissement (damp) Limite de temps
		 * (si spécifié, autrement disparait par manque de vitesse) / 0 Nombre de
		 * Particle
		 */
		AllParticles.add(new Particles(type, taille, p, vel, damp, timeLimit, nb));
	}

	public void setStroke(boolean s) {
		stroke = s;
	}

	public void setColor(color c) {
		col = c;
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
	 * spécifié, autrement disparait par manque de vitesse) / 0 Nombre de Particle
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
		 * (si spécifié, autrement disparait par manque de vitesse) / 0 Nombre de
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

			/*
			 * Type de forme Taille Position Vitesse Ralentissement (damp) Limite de temps
			 * (si spécifié, autrement disparait par manque de vitesse)
			 */

			public Particle(ParticleType t, float ta, PVector p, float bV, float d, float tL) {
				type = t;
				taille = ta;
				pos = p.copy();

				vel = random(bV / 2, bV * 2);

				ori = PVector.random2D();
				ori.setMag(1);

				damp = random(d / 10, d);

				timer = millis();
				timeLimit = random(tL / 2, tL * 2);
				isTimed = true;
			}

			public Particle(ParticleType t, float ta, PVector p, float bV, float d) {
				type = t;
				taille = ta;
				pos = p.copy();

				vel = random(bV / 2, bV * 2);

				ori = PVector.random2D();
				ori.setMag(1);

				damp = random(d / 10, d);

				isTimed = false;
			}

			public void Update() {
				vel = MinigameDrill.lerp(vel, 0, damp);
				ori.setMag(vel);

				pos.add(ori);

				// Soit il est timé soit il disparait quand il a plus de vitesse
				if (!isTimed) {
					if (vel < 0.1)
						isMort = true;
				} else {
					if (millis() - timer > timeLimit)
						isMort = true;
				}
			}

			public void Display() {
				push();

				translate(pos.x, pos.y);

				rectMode(CENTER);

				strokeWeight(2);

				switch (type) {

				case Square:
					rect(0, 0, taille, taille);
					break;

				case Circle:
					ellipse(0, 0, taille, taille);
					break;
				}

				pop();
			}
		}
	}
}

enum ParticleType {
	Square, Circle
}