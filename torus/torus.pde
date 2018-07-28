void setup() {
  size(750, 750, P3D);
  smooth(8);
  ellipseMode(RADIUS);
  stroke(128);
  noFill();
  ortho();
}


float R = 200;
float r = 100;
int circles = 16;
int vertices = 36;

void drawPoint(float x, float y) {
  point(
    sin(x * TAU) * (R + sin(y * TAU) * r),
    cos(x * TAU) * (R + sin(y * TAU) * r),
    cos(y * TAU) * r);
}

void draw() {
  background(0);
  push();
  translate(width / 2, height / 2);
  rotateX(TAU / 4 - isoAngle); // upward for isometric projection with Z pointing up
  // rotateZ(TAU / 8);

  float x = mouseX * 1.0 / width;
  float y = mouseY * 1.0 / height;

  for (int i = 0; i < circles; i++) {
    float th = i / float(circles);

    push();
      rotateZ(TAU * th);
      beginShape();
        for (int v = 0; v < vertices; v++) {
          float vth = v / float(vertices);
          vertex(0, R + cos(vth * TAU) * r, sin(vth * TAU) * r);
        }
      endShape(CLOSE);
    pop();

    push();
      translate(0, 0, sin(th * TAU) * r);
      float radius = R + cos(th * TAU) * r;
      ellipse(0, 0, radius, radius);
    pop();

    push();
      strokeWeight(10);

      stroke(255);
      drawPoint(0, 0);

      stroke(255, 0, 0);
      drawPoint(x, y);
    pop();
  }

  pop();
}


////////////////////////////////////////////////////////////////////////////////


// height of an equilateral triangle with side length 1: 0.8660254
float triHeight = sqrt(3) / 2;
// rotation angle on x-axis for isometric projection: 35.26439 deg
float isoAngle = atan(1 / sqrt(2));

float easeOut(float value) {
  return 1 - sq(1 - value);
}

float ease(float value) {
  return 3 * pow(value, 2) - 2 * pow(value, 3);
}

float ease(float value, float exp) {
  return value < 0.5 ?
    pow(value * 2, exp) / 2 :
    1 - pow((1 - value) * 2, exp) / 2;
}

void push() {
  pushMatrix();
  pushStyle();
}

void pop() {
  popStyle();
  popMatrix();
}

// Clamp/constrain a value between 0 and 1.
float c01(float value) {
  return constrain(value, 0, 1);
}
