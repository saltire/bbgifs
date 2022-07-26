int samplesPerFrame = 8;
int numFrames = 860;
float shutterAngle = .6;

boolean recording = false;
boolean mouseControl = false;

void setup() {
  size(720, 720, P3D);
  pixelDensity(recording ? 1 : 2);
  smooth(8);
  rectMode(CENTER);
  fill(32);
  noStroke();
  result = new int[width * height][3];
}

int count = 14;
float maxSize = 340;

float easeSin(float g, float easing){
  return lerp(-.5, .5, ease(norm(sin(g), -1, 1), easing));
}

void draw_() {
  background(250);
  push();
  translate(width / 2, height / 2);

  for (int i = 0; i < count; i++) {
    float easing = lerp(12, 2, sqrt(i / float(count)));
    float size = map(i, 0, count, maxSize, 0);
    fill(i % 2 == 0 ? 32 : 250);
    push();
    rotate(QUARTER_PI + QUARTER_PI * easeSin(TWO_PI * (i + 1) * t, easing));
    rect(0, 0, size, size);
    pop();
  }

  pop();
}
