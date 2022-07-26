int samplesPerFrame = 4;
int numFrames = 240;
float shutterAngle = 1;

boolean recording = false;
boolean mouseControl = false;

void setup() {
  size(720, 720, P3D);
  pixelDensity(recording ? 1 : 2);
  smooth(8);
  rectMode(CENTER);
  stroke(25);
  noFill();
  strokeWeight(2.5);
  result = new int[width * height][3];
}

int N = 13;
float sp = 20;
float l = sp + 1.25;

void thing(float q) {
  line(lerp(-l / 2, l / 2, q), -l / 2, lerp(l / 2, -l / 2, q), l / 2);
}

void draw_() {
  background(250);
  push();
  translate(width / 2, height / 2);
  for (int i = -N; i < N; i++) {
    for (int j = -N; j < N; j++) {
      float x = (i + .5) * sp;
      float y = (j + .5) * sp;
      float tt = -t - 0.00031 * (x * x + y * y);
      tt = (tt + 1000) % 1;
      tt = norm(cos(TAU * tt), 1, -1);
      tt = ease(tt, 5);
      push();
      translate(x, y);
      rotate(TAU / 4 * (i + j));
      thing(tt);
      pop();
    }
  }
  pop();
}
