package Main;

import Entities.*;
import java.util.*;
import processing.core.*;
import processing.net.*;

public class UI {
	Player player;
	ArrayList<Bouton> AllBoutons;

	public UI(Player p) {
		player = p;
		AllBoutons = new ArrayList<Bouton>();
		SetAllBoutons();
	}

	public void Display() {
		if (MinigameDrill.playState == MinigameDrill.PlayState.Play) {
			DisplayMateriaux(player);
		}
		DisplayNet();
		DisplayBoutons();
	}

	private void DisplayMateriaux(Player player) {

		MinigameDrill.window.push();
		MinigameDrill.window.rectMode(MinigameDrill.CORNERS);
		MinigameDrill.window.fill(255, 225, 255, 20);
		MinigameDrill.window.rect(MinigameDrill.window.width * 4 / 5, 0, MinigameDrill.window.width,
				MinigameDrill.window.height / 2);
		MinigameDrill.window.pop();

		int nbTypes = Collectable.CollectableType.values().length;
		for (int i = 0; i < Collectable.CollectableType.values().length; i++) {
			MinigameDrill.window.push();
			MinigameDrill.window.fill(255);
			MinigameDrill.window.textSize(20);
			MinigameDrill.window.textAlign(processing.core.PGraphics.LEFT);

			MinigameDrill.window.text(Collectable.CollectableType.values()[i].toString(),
					MinigameDrill.window.width * 4.1f / 5, (i + 0.5f) * (MinigameDrill.window.height / 2) / nbTypes);
			MinigameDrill.window.text(player.Stock.get(Collectable.CollectableType.values()[i].toString()),
					MinigameDrill.window.width * 4.7f / 5, (i + 0.5f) * (MinigameDrill.window.height / 2) / nbTypes);

			MinigameDrill.window.pop();
		}
	}

	private void DisplayNet() {
		MinigameDrill.window.push();
		try {
			MinigameDrill.window.rectMode(processing.core.PGraphics.CORNER);
			MinigameDrill.window.fill(255, 255, 255, 50);
			MinigameDrill.window.rect(0, 0, 150, 50);
			MinigameDrill.window.fill(255);
			MinigameDrill.window.textAlign(processing.core.PGraphics.LEFT);
			MinigameDrill.window.textSize(10);
			if (ServerManager.type == ServerManager.NetType.Server) {
				if (ServerManager.getServer() != null) {
					MinigameDrill.window.text("Server", 20, 20);
					MinigameDrill.window.text("IP : " + Server.ip(), 20, 30);
					// text("Clients connect�s : "+s.server.clientCount, 20, 40);
				}
			} else {
				if (ServerManager.getClient() != null && ServerManager.getClient().ip() != null) {
					MinigameDrill.window.text("Client", 20, 20);
					MinigameDrill.window.text("Connect� : " + ServerManager.getClient().ip(), 20, 30);
				} else {
					MinigameDrill.window.text("Problème de connexion au server", 20, 30);

				}
			}
		} catch (Exception e) {
			MinigameDrill.println("oopsi doopsi" + e);
		}
		MinigameDrill.window.pop();
	}

	private void DisplayBoutons() {
		for (Bouton b : AllBoutons) {
			if (MinigameDrill.playState.toString().equals(b.route)) {
				MinigameDrill.window.push();
				StyleBoutons();
				b.Update();
				MinigameDrill.window.pop();
			}
		}
	}

	public void SetAllBoutons() {
		// Bouton titre
		AllBoutons.add(new Bouton(MinigameDrill.window.width / 2, MinigameDrill.window.height / 2, 500, 200, "Title",
				"Play !") {
			public void Action() {
				MinigameDrill.playState = MinigameDrill.PlayState.Play;
			}
		});

		// Bouton changement server/client
		AllBoutons.add(new Bouton(MinigameDrill.window.width / 2, MinigameDrill.window.height * 3 / 4, 500, 100,
				"Title", "Vous êtes : " + ServerManager.type.toString()) {
			public void Action() {
				if (ServerManager.type == ServerManager.NetType.Server) {
					ServerManager.type = ServerManager.NetType.Client;
					// MinigameDrill.serverManager.UpdateInstance();
				} else {
					ServerManager.type = ServerManager.NetType.Server;
				}

				this.texte = "Vous �tes : " + ServerManager.type.toString();
			}
		});

		// Bouton quitter
		AllBoutons.add(new Bouton(MinigameDrill.window.width * 3 / 4, MinigameDrill.window.height / 6, 50, 50,
				"Title", "X") {
			public void Action() {
				ServerManager.connexionClient = null;
				MinigameDrill.mgd.exit();
			}
		});
	}

	// ------------------------BOUTON

	public class Bouton {
		private PVector pos, taille;
		public String route, texte;
		private boolean clicked = false, lastState = false;

		public Bouton(float x, float y, float tx, float ty, String r, String t) {
			pos = new PVector(x, y);
			taille = new PVector(tx, ty);
			route = r;
			texte = t;
		}

		public void Update() {
			if (MinigameDrill.mgd.mouseX > pos.x - taille.x / 2 && MinigameDrill.mgd.mouseX < pos.x + taille.x / 2
					&& MinigameDrill.mgd.mouseY > pos.y - taille.y / 2
					&& MinigameDrill.mgd.mouseY < pos.y + taille.y / 2) {
				clicked = false;
				MinigameDrill.window.fill(50);
				MinigameDrill.window.strokeWeight(3);
				if (MinigameDrill.mgd.mousePressed) {
					MinigameDrill.window.fill(100);
					clicked = true;
				}
				if (!clicked && lastState)
					Action();
				lastState = clicked;
			}
			MinigameDrill.window.rect(pos.x, pos.y, taille.x, taille.y);
			MinigameDrill.window.fill(255);
			MinigameDrill.window.text(texte, pos.x, pos.y);
		}

		public void Action() {
			MinigameDrill.println("Bouton press� :", route, texte);
		}

	}

	public void StyleBoutons() {
		MinigameDrill.window.fill(0);
		MinigameDrill.window.stroke(255);
		MinigameDrill.window.strokeWeight(1);
		MinigameDrill.window.textAlign(MinigameDrill.CENTER);
		MinigameDrill.window.textSize(50);
		MinigameDrill.window.rectMode(MinigameDrill.CENTER);
	}
}
