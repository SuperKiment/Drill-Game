package Entities;

import Main.MinigameDrill;
import java.util.HashMap;
import processing.core.*;
import processing.data.*;
import Utils.Utils;
import Entities.Collectable;

import Main.Camera;

public class Player extends Entity {
	private boolean isMoving = false, collecting = false, controllable = true, loaded = false;

	public HashMap<String, Float> Stock;

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

		// Initialise tous les types de collectables dans les keys
		Stock = new HashMap<String, Float>();
		for (int i = 0; i < Collectable.CollectableType.values().length; i++) {
			Stock.put(Collectable.CollectableType.values()[i].toString(), 0f);
		}

		isPlayer = true;
		speed = 3;
	}

	public void Display() {
		if (ID.equals("52")) {
			MinigameDrill.println(pos);
		}
		push();
		translate(pos.x, pos.y);
		text(ID, 0, taille.y * 2);
		rotate(dir.heading());
		rect(0, 0, taille.x, taille.y);
		rect(-taille.x / 2, 0, taille.x / 2, taille.y / 2);
		fill(125);
		ellipse(taille.x / 2.5, taille.y / 3, 10, 10);
		ellipse(taille.x / 2.5, -taille.y / 3, 10, 10);
		pop();
	}

	public void Update() {
		Direction();
		Deplacement();

		if (controllable) {
			if (MinigameDrill.collect)
				collecting = Collect();
			else
				collectable = null;
		} else {
			// Se déplalcer grace au dataIn du serv ?
		}
	}

	// Définit la direction du player
	private void Direction() {
		if (controllable) {
			isMoving = false;
			if (MinigameDrill.up || MinigameDrill.right || MinigameDrill.left || MinigameDrill.down) {

				isMoving = true;

				if (MinigameDrill.up)
					dir.y -= 1;
				if (MinigameDrill.down)
					dir.y += 1;
				if (MinigameDrill.left)
					dir.x -= 1;
				if (MinigameDrill.right)
					dir.x += 1;
			}

			if (collecting && collectable != null) {
				DoCollect();
			}
		}

		dir.setMag(speed);
	}

	// Fait se déplacer
	private void Deplacement() {
		if (isMoving || collecting)
			pos.add(dir);
	}

	// Vérifie si on peut bien collecter
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

	// Faire la collection du collectable
	private void DoCollect() {
		dir = PVector.sub(collectable.pos.copy(), pos.copy());
		MinigameDrill.camera.Shake(1);
		MinigameDrill.miningParticles.addParticles(pos);
		String collectType = collectable.getTypeAsString();
		addStock(collectType, 1);
		collectable.Collected();
	}

	// Ajouter du collectable au hashmap
	private void addStock(String type, float amount) {
		Stock.put(type, Stock.get(type) + amount);
	}

	public void loadData(HashMap<String, String> dataPlayer) {
		if (!loaded) {
			if (dataPlayer.containsKey("posX"))
				pos.set(Float.valueOf(dataPlayer.get("posX")), Float.valueOf(dataPlayer.get("posY")));
			loaded = true;
		}
		if (dataPlayer.containsKey("dirX")) {
			dir.set(Float.valueOf(dataPlayer.get("dirX")), Float.valueOf(dataPlayer.get("dirY")));
			dir.setMag(1);
		}
		if (dataPlayer.containsKey("tailleX"))
			taille.set(Float.valueOf(dataPlayer.get("tailleX")), Float.valueOf(dataPlayer.get("tailleY")));
		if (dataPlayer.containsKey("ID"))
			ID = dataPlayer.get("ID");
		if (dataPlayer.containsKey("isMoving")) {
			isMoving = Utils.StringToBoolean(dataPlayer.get("isMoving"));
			MinigameDrill.println(dir);
		}
	}

	public JSONObject getJSON() {
		JSONObject json = new JSONObject();

		json.setJSONObject("pos", Utils.PVectorToJSON(pos));
		json.setJSONObject("taille", Utils.PVectorToJSON(taille));
		json.setJSONObject("dir", Utils.PVectorToJSON(dir));
		json.setString("class", Utils.getClearClass(this));
		json.setString("ID", ID);
		json.setJSONObject("Stock", getStockJSON());

		return json;
	}

	private JSONObject getStockJSON() {
		JSONObject json = new JSONObject();
		MinigameDrill.println();
		json.setFloat("Bois", Stock.get("Bois"));
		Stock.keySet().forEach((cle) -> {
			json.setFloat(cle, Stock.get(cle));
		});

		return json;
	}
}
