package Main;

import processing.net.Client;
import java.util.Random;
import processing.net.Server;
import java.util.*;
import Entities.*;
import processing.data.*;

public class ServerManager {

	public enum NetType {
		Client, Server
	}

	public String ID;

	private static Client client;
	private static Server server;
	public static NetType type;
	public int port = 5204;

	public static ConnexionClient connexionClient;

	public static final String separPlayer = " | ";

	public static final String separData = " / ";

	float timerReconnexion = 0, cooldownReconnexion = 1000;

	ArrayList<String> EnvoiBuffer;
	HashMap<String, HashMap<String, String>> DataIn;

	MinigameDrill minigameDrill;
	String ipClient;

	ServerManager(MinigameDrill mgd, NetType t, String ip) {
		connexionClient = new ConnexionClient();
		connexionClient.start();

		minigameDrill = mgd;
		ipClient = ip;

		DataIn = new HashMap<String, HashMap<String, String>>();

		// Init un ID random
		Random r = new Random();
		ID = Float.toString(r.nextInt(1000, 9999));
		EnvoiBuffer = new ArrayList<String>();
		type = t;
		/*
		 * UpdateInstance(); try { switch (t) { case Client:
		 * client.write(ToWriteClient("ID") + ID); break; case Server: break; } } catch
		 * (Exception e) { MinigameDrill.
		 * println("Erreur lors de la création des client server dans le setup"); }
		 */
	}

	public void PreUpdate() {
		EnvoiBuffer.clear();

		if (type == NetType.Server) {
			// SERVER RECEPTION
			if (server != null) {
				// R�cup et traitement des donn�es
				Client c = server.available();
				while (c != null) {
					ServerReception(c);
					c = server.available();
				}
			} else
				UpdateInstance();

		} else if (type == NetType.Client) {
			// CLIENT RECEPTION

			if (client == null) {
				UpdateInstance();
				return;
			}

			// Si on est connect�s, envoyer les donnees. Sinon se reconnecter
			if (client.ip() == null) {
				if (MinigameDrill.mgd.millis() - timerReconnexion > cooldownReconnexion) {
					timerReconnexion = MinigameDrill.mgd.millis();
					UpdateInstance();
				}
			} else {

				// Recup des donnees
				String read = client.readString();
				MinigameDrill.println(read);

				if (read != null && read != "") {
					// Decoupe le string en hashmap
					DataIn = StringToHashClient(read);
					// traite et cree ou bouge les entites
					TraiterDonneesFromServer();
				}
			}
		}
	}

	public void PostUpdate() {
		if (type == NetType.Server) {
			// SERVER ENVOI
			if (server == null) {
				UpdateInstance();
				return;
			}

			String dataOut = "";
			if (EnvoiBuffer != null && EnvoiBuffer.size() > 0) {
				for (String data : EnvoiBuffer) {
					dataOut += data;
				}
				server.write(dataOut);
			}

		} else {
			// CLIENT ENVOI

			if (client == null) {
				UpdateInstance();
				return;
			}

			if (client.ip() == null) {
				if (MinigameDrill.mgd.millis() - timerReconnexion > cooldownReconnexion) {
					timerReconnexion = MinigameDrill.mgd.millis();
					UpdateInstance();
				}
				return;
			}

			EnvoiFromClient();

		}
	}

	private void ServerReception(Client c) {
		String data = c.readString();
		MinigameDrill.println("dataIn : " + data);
		c = server.available();

	}

	// Division du String en HashMap, DEPRECIE
	public HashMap<String, HashMap<String, String>> StringToHashClient(String base) {
		HashMap<String, HashMap<String, String>> res = new HashMap<String, HashMap<String, String>>();

		String[] dataIn = MinigameDrill.split(base, separPlayer);

		// Division des |
		for (String dataPlayer : dataIn) {
			HashMap<String, String> playerData = new HashMap<String, String>();

			if (dataPlayer != "") {
				String[] datas = MinigameDrill.split(dataPlayer, separData);

				// Division des /
				for (String data : datas) {
					if (data != "") {
						try {
							String[] fragment = MinigameDrill.split(data, ':');
							playerData.put(fragment[0], fragment[1]);
						} catch (Exception e) {
							MinigameDrill.println("Erreur sur : " + data);
						}
					}
				}
			}

			res.put(playerData.get("ID"), playerData);
		}

		res.remove(null);

		return res;
	}

	// Traitement des donn�es
	private void TraiterDonneesFromServer() {
		ArrayList<String> AllIDs = new ArrayList<String>();
		for (Entity e : Entity.AllEntities) {
			AllIDs.add(e.ID);
		}

		for (String id : DataIn.keySet()) {
			if (!AllIDs.contains(id)) {
				Entity.AddEntityFromServer(DataIn.get(id));
			} else {
				for (Entity e : Entity.AllEntities) {
					if (e.ID.equals(id)) {
						e.loadData(DataIn.get(id));
					}
				}
			}
		}
	}

	private void EnvoiFromClient() {
		for (Entity e : Entity.AllEntities) {
			if (!e.isPlayer)
				continue;

			Player p = (Player) e;
			if (!p.isControllable())
				continue;

			JSONObject envoi = TemplateEnvoi(p.getJSON());
			MinigameDrill.println(envoi);
			client.write(envoi.toString());
		}
	}

	private JSONObject TemplateEnvoi(JSONObject info) {
		JSONObject envoi = new JSONObject();
		envoi.setString("Type", type.toString());
		envoi.setString("ID", ID);
		envoi.setJSONObject("Info", info);
		return envoi;
	}

	public void AddEnvoi(String envoi) {
		EnvoiBuffer.add(envoi);
	}

	public void UpdateInstance() {
		/*
		 * switch (type) { case Client: client = new Client(minigameDrill, ipClient,
		 * port); break; case Server: server = new Server(minigameDrill, port); break; }
		 */
	}

	public static Client getClient() {
		return client;
	}

	public static Server getServer() {
		return server;
	}

	// DEPRECIE
	public static String ToWriteClient(String w) {
		return " / " + w + ":";
	}

	// THREAD CONNEXION CLIENT ET LOAD SERVER (ptet utile /shrug mmdrr)
	class ConnexionClient extends Thread {

		private final int cooldownNoProb = 2000, cooldownYesProb = 500;

		// Sert à timer les tests
		private boolean problem = false;

		public void run() {
			while (true) {

				MinigameDrill.println("Test connexion client");
				problem = false;

				if (type == NetType.Client && (client == null || client.ip() == null)) {
					problem = true;
					client = new Client(minigameDrill, ipClient, port);
				} else if (type == NetType.Server && server == null) {
					problem = true;
					server = new Server(minigameDrill, port);
				}

				Sleep();
			}
		}

		private void Sleep() {
			try {
				if (problem)
					sleep(cooldownYesProb);
				else
					sleep(cooldownNoProb);
			} catch (Exception e) {
				MinigameDrill.println("shit lors du sleep ???");
			}
		}
	}
}
