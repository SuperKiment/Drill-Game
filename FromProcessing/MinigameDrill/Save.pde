public class SaveManager {
  public String path = "saves/";
  private String savesIndexPath = "saves/saves.txt";
  public String[] saves;

  public SaveManager() {
    saves = loadStrings(savesIndexPath);
  }

  public void LoadData(String JSONPath) {
    JSONObject all = loadJSONObject("saves/"+JSONPath+".json");
    
    Entity.loadFromJSON(all.getJSONArray("Entities"));
  }

  public void Save(String name) {
    JSONObject save = new JSONObject();

    save.setJSONArray("Entities", Entity.getAllEntitiesJSON());

    saveJSONObject(save, path+name+".json");
  }
}
