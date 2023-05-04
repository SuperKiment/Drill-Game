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
		MinigameDrill.window.push();
		MinigameDrill.window.rectMode(MinigameDrill.window.CENTER);
	    switch(type) {
	      case Pierre:
	    	  MinigameDrill.window.fill(125);
	      break;
	      case Bois:
	    	  MinigameDrill.window.fill(0xFF935912);
	      break;
	      case Or:
	    	  MinigameDrill.window.fill(0xFFE0ED32);
	      break;
	      case Argent:
	    	  MinigameDrill.window.fill(0xFFC2D5D6);
	      break;
	      case Uranium:
	    	  MinigameDrill.window.fill(0xFF2FDE4D);
	      break;
	    }
	    MinigameDrill.window.rect(pos.x, pos.y, taille.x, taille.y);
	    MinigameDrill.window.pop();
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