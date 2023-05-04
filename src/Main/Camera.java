package Main;

import processing.core.*;
import java.util.Random;

public class Camera {

	public PVector translate;
	private PVector shaking;
	private Random r;

	public Camera() {
		translate = new PVector();
		shaking = new PVector();
		r = new Random();
	}

	public void Update() {
		translate.lerp(new PVector(), 0.05f);

		if (shaking.x*3 > shaking.x/2 && shaking.y*3 > shaking.y/2) {
			translate.x = r.nextFloat(shaking.x / 2, shaking.x * 3);
			translate.y = r.nextFloat(shaking.y / 2, shaking.y * 3);
		}
		
		shaking.lerp(new PVector(), 0.05f);
	}

	public void Shake(float shake) {
		shaking.x = r.nextFloat(shake / 3, shake * 2);
		shaking.y = r.nextFloat(shake / 3, shake * 2);
	}

	public void Translate() {
		MinigameDrill.window.translate(translate.x, translate.y);
	}
}