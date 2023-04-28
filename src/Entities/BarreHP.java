package Entities;
import processing.core.*;


public class BarreHP {

	private float HP, baseHP;

	  BarreHP(float bhp) {
	    baseHP = bhp;
	    HP = baseHP;
	  }

	  void Display(float hp) {
	    HP = hp;

	    push();

	    fill(50);
	    rect(0, 0, hp, 20);

	    fill(255, 0, 0);
	    rect(0, 0, hp-2, 20-2);

	    pop();
	  }
	}