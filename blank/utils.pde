// Height of an equilateral triangle with side length 1: ~0.8660254
float triHeight = sqrt(3) / 2;
// Rotation angle on x-axis for isometric projection: ~35.26439 deg
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
