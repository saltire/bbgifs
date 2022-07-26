int samplesPerFrame = 8;
int numFrames = 320;
float shutterAngle = .7;

boolean recording = false;
boolean mouseControl = false;

void setup() {
  size(720, 720, P3D);
  pixelDensity(recording ? 1 : 2);
  smooth(8);
  rectMode(CENTER);
  stroke(32);
  noFill();
  strokeWeight(3);
  result = new int[width * height][3];
}

int N = 8;
int n = 720;
float rotMax = PI * .5;
float twist = PI / 4;
float rMin = 65;
float rMax = 200;

void circ(float r, float phase, boolean black) {
  strokeWeight(black ? 6 : 18);
  beginShape();
  for (int i = 0; i < n; i++) {
    float th = TWO_PI * i / n;
    float x = r * cos(th);
    float y = r * sin(th);

    float rot = rotMax * sin(TWO_PI * t + phase - twist * y / r);

    float briteness = c01(norm(x * sin(rot), -rMax, rMax));
    briteness = lerp(220, 20, briteness);
    stroke(black ? briteness : 250);

    vertex(x * cos(rot), y, x * sin(rot));
  }
  endShape(CLOSE);
}

void circs() {
  for (int i = 0; i < N; i++) {
    circ(map(i, 0, N - 1, rMin, rMax), -HALF_PI * i / N, true);
    push();
    translate(0, 0, -9);
    // circ(map(i, 0, N - 1, rMin, rMax), -HALF_PI * i / N, false);
    pop();
  }
}

void draw_() {
  background(250);
  push();
  translate(width / 2, height / 2);
  circs();
  pop();
}
