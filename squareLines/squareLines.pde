int samplesPerFrame = 8;
int numFrames = 120;
float shutterAngle = .7;

boolean recording = false;
boolean mouseControl = false;

void setup() {
  size(800, 800, P3D);
  smooth(8);
  rectMode(CENTER);
  stroke(250);
  strokeWeight(3);
  result = new int[width * height][3];
}

int strips = 12;
int lines = 30;
float size = 420;
float margin = 5;
float sWidth = size / strips - margin;
float amount = 30;

void strip(float q) {
  for (int i = 0; i < lines; i++) {
    float qq = i / float(lines - 1);
    float amt = sin(TAU / 2 * qq) * amount;
    float y = map(i, 0, lines - 1, -size / 2, size / 2) + amt * sin(TAU * q - TAU * qq);
    line(-sWidth / 2, y, sWidth / 2, y);
  }
}

void squa() {
  for (int i = 0; i < strips; i++) {
    push();
    translate(map(i, 0, strips - 1, -size / 2 + sWidth / 2 - 1, size / 2 - sWidth / 2 + 1), 0);
    strip(t - i / float(strips));
    pop();
  }
}

PImage f1, f2;

void draw_() {
  background(32);
  push();
  translate(width / 2, height / 2);
  scale(1.2);

  squa();
  f1 = get();

  background(32);
  push();
  scale(1.006, 1.003);
  squa();
  pop();
  f2 = get();

  background(32);
  push();
  scale(1.012, 1.006);
  squa();
  pop();

  pop();

  loadPixels();
  f1.loadPixels();
  f2.loadPixels();

  for(int i = 0; i < pixels.length; i++)
    pixels[i] = color(red(f1.pixels[i]), green(f2.pixels[i]), blue(pixels[i]));
  updatePixels();
}
