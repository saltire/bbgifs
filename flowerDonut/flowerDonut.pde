boolean recording = false;

int samplesPerFrame = 4;
int numFrames = 180;
float shutterAngle = .6;

void setup() {
  size(720, 720, P3D);
  pixelDensity(recording ? 1 : 2);
  smooth(8);
  noFill();
  strokeWeight(10);
  ortho();

  result = new int[width * height][3];
}

void strand(float phase) {
  beginShape();
  for (int i = 0; i < points; i++) {
    x = i * 1.0 / (points - 1);
    y = sin(TWO_PI * t - PI * x + phase) * amp;
    r = lerp(rInner, rOuter, x);
    vertex(r * cos(y), r * sin(y));
  }
  endShape();
}

int count = 12;
int points = 60;
float rInner = 75;
float rOuter = 255;
float amp = .4;
float x, y, r;

void draw_() {
  blendMode(MULTIPLY);
  background(250);
  push();
  translate(width / 2, height / 2);
  for (int i = 0; i < count; i++) {
    push();
    rotate(TWO_PI * i / count);

    stroke(#FFDC00);
    strand(0);

    stroke(#39CCCC);
    strand(TWO_PI / 3);

    stroke(#F012BE);
    strand(-TWO_PI / 3);

    pop();
  }

  // Draw a circle with a radius of (inner radius + 5) pixels.
  push();
  translate(0, 0, 1); // Bring forward on the z-axis
  blendMode(NORMAL);
  fill(250);
  noStroke();
  ellipse(0, 0, 2 * rInner + 5, 2 * rInner + 5);

  // Draw a triangle strip forming a big ring, masking from the outer radius to 1000 pixels out.
  beginShape(TRIANGLE_STRIP);
  for (int i = 0; i <= 500; i++) {
    vertex((rOuter - 5) * cos(TWO_PI * i / 500), (rOuter - 5) * sin(TWO_PI * i / 500));
    vertex(1000 * cos(TWO_PI * i / 500), 1000 * sin(TWO_PI * i / 500));
  }
  endShape();
  pop();

  pop();
}
