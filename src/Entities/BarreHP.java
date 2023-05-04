package Entities;
import Main.MinigameDrill;

public class BarreHP {

	private float HP, baseHP;

	  BarreHP(float bhp) {
	    baseHP = bhp;
	    HP = baseHP;
	  }

	  void Display(float hp) {
	    HP = hp;

	    MinigameDrill.window.push();

	    MinigameDrill.window.fill(50);
	    MinigameDrill.window.rect(0, 0, hp, 20);

	    MinigameDrill.window.fill(255, 0, 0);
	    MinigameDrill.window.rect(0, 0, hp-2, 20-2);
	    MinigameDrill.window.pop();
	  }
	}