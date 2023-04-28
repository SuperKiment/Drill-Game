package Entities;

import Main.MinigameDrill;

public class Collectable extends Entity {

	public enum CollectableType {
		Pierre, Bois, Or, Argent, Uranium
	}

	public CollectableType type;

	public Collectable() {
		Constructor();
	}

	public Collectable(float x, float y) {
		Constructor();
		pos.set(x, y);
		speed = 0;
	}

	public Collectable(float x, float y, CollectableType t) {
		Constructor();
		pos.set(x, y);
		speed = 0;
		type = t;
	}

	protected void Constructor() {
		super.Constructor();
		isCollectable = true;
		taille.set(50, 50);
		type = CollectableType.Pierre;
	}

	public void Display() {
	    push();
	    switch(type) {
	      case Pierre:
	      fill(125);
	      break;
	      case Bois:
	      fill(#935912);
	      break;
	      case Or:
	      fill(#E0ED32);
	      break;
	      case Argent:
	      fill(#C2D5D6);
	      break;
	      case Uranium:
	      fill(#2FDE4D);
	      break;
	    }
	    rect(pos.x, pos.y, taille.x, taille.y);
	    pop();
	  }

	public void setMort() {
		super.setMort();
		MinigameDrill.finishMiningParticles.addParticles(pos);
	}

	public String getTypeAsString() {
		String res = type.toString();
		return res;
	}
}