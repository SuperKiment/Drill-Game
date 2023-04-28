package Main;

import processing.core.*;

public class Camera {

	public PVector translate;
	private PVector shaking;

	public Camera() {
		translate = new PVector();
		shaking = new PVector();
	}

	public void Update() {

		translate.lerp(new PVector(), 0.05);

		translate.x = random(shaking.x / 3, shaking.x * 2);
		translate.y = random(shaking.x / 3, shaking.x * 2);

		shaking.lerp(new PVector(), 0.05);
	}

	public void Shake(float shake) {
		shaking.x = random(shake / 3, shake * 2);
		shaking.y = random(shake / 3, shake * 2);
	}

	public void Translate() {
		translate(translate.x, translate.y);
	}
}