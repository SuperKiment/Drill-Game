import processing.net.*;

Server s;
String data1 = " |  / ID:46513 / posX:",
  data2 = " / posY:789 / class:Player / type:Argent |  / posX:155 / posY:155 / dirX:", data3 = " / name:Salut les mecs / ID:52 / class:Player / isMoving:1";
float x = 50;
float sincos = 0;

PVector dir;

void setup() {
  s = new Server(this, 5204);
  dir = new PVector(0, 0);
}

void draw() {
  sincos += 0.05f;

  dir.set(sin(sincos), cos(sincos));

  x++;
  if (x>500) x=50;
  s.write(data1+x+data2+dir.x+" / dirY:"+dir.y+data3);

  println("Data Out : "+data1+x+data2+round(dir.x+1)+" / dirY:"+round(dir.y+1)+data3);

  boolean ok = true;
  while (ok) {
    Client c = s.available();

    if (c != null) {
      println("Data In : "+c.readString());
    } else ok = false;
  }
}
