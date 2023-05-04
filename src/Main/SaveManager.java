package Main;

import processing.data.*;
import Entities.Entity;

public class SaveManager {
	public String path = "saves/";
	private String savesIndexPath = "saves/saves.txt";
	public String[] saves;

	public SaveManager() {
		saves = MinigameDrill.mgd.loadStrings(savesIndexPath);
	}

	public void LoadData(String JSONPath) {
		JSONObject all = MinigameDrill.mgd.loadJSONObject("saves/" + JSONPath + ".json");

		Entity.loadAllFromJSON(all.getJSONArray("Entities"));
	}

	public void Save(String name) {
		JSONObject save = new JSONObject();

		save.setJSONArray("Entities", Entity.getAllEntitiesJSON());

		MinigameDrill.mgd.saveJSONObject(save, path + name + ".json");
	}
}