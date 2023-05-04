package Utils;

import Entities.Entity;
import java.util.*;
import processing.data.*;
import processing.core.*;
import Main.MinigameDrill;

public class Utils {
	public static Entity getEntityOnPos(ArrayList<Entity> array, float x, float y) {
		for (Entity e : array) {
			if (x > e.getPos().x - e.getTaille().x / 2 && x < e.getPos().x + e.getTaille().x / 2
					&& y > e.getPos().y - e.getTaille().y / 2 && y < e.getPos().y + e.getTaille().y / 2) {
				return e;
			}
		}
		return null;
	}

	public static boolean StringToBoolean(String s) {
		if (s.equals("true"))
			return true;
		else if (s.equals("false"))
			return false;
		else if (s.equals("0"))
			return false;
		else if (s.equals("1"))
			return true;
		return false;
	}

	public static String BooleanToNumString(boolean b) {
		return b ? "1" : "0";
	}

	public static JSONObject PVectorToJSON(PVector p) {
		JSONObject json = new JSONObject();
		json.setFloat("x", p.x);
		json.setFloat("y", p.y);
		return json;
	}

	public static String getClearClass(Object o) {
		//MinigameDrill.print(o.getClass().toString());
		return MinigameDrill.split(o.getClass().toString(), ".").length > 1 ? MinigameDrill.split(o.getClass().toString(), ".")[1] : "Entity";
	}
}
