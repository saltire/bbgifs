int samplesPerFrame = 4;
int numFrames = 600;
float shutterAngle = .5;

boolean recording = false;
boolean mouseControl = false;

void setup() {
  size(800, 800, P3D);
  pixelDensity(recording ? 1 : 2);
  smooth(8);
  rectMode(CENTER);
  fill(32);
  noStroke();
  ortho();
  result = new int[width * height][3];
}

int slices = 12;
float size = 340;
float margin = 8;

void drawSlice() {
  // Draw a grey box for the slice.
  fill(90);
  box(size, size / slices, size);

  fill(250);

  // Draw the edges of the slice.
  for (int i = 0; i < 4; i++) {
    push();
    rotateY(HALF_PI * i);
    translate(0, 0, size / 2 + .1);
    rect(0, 0, size - margin, size / slices - margin);
    pop();
  }

  // Draw the top and bottom of the slice (though bottom is currently hidden).
  for (int i = 0; i < 1; i++) {
    push();
    rotateX(HALF_PI + PI * i);
    translate(0, 0, size / (2 * slices) + .1);
    rect(0, 0, size - margin, size - margin);
    pop();
  }
}

void draw_() {
  background(0);
  push();
  translate(width / 2, height / 2);
  rotateX(-isoAngle);
  rotateY(QUARTER_PI);

  for (int i = 0; i < slices; i++) {
    push();
    translate(0, size / slices * (i - .5 * (slices - 1)), 0);
    rotateY(-HALF_PI * (i + 1) * t); // Rotate each slice one quarter-turn more than the previous.
    drawSlice();
    pop();
  }
  pop();
}
