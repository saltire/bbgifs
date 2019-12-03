int iterations = 16;

float angleDeltaMin = 0;
float angleDeltaMax = TAU / 4;
float angleDelta;

// float scale = 0.6182;
float lengthScale = 1 / 1.456;
float weightScale = 1 / 1.333;

void settings() {
  size(800, 800);
}

void draw_() {
  background(255);
  stroke(0);
  strokeCap(SQUARE);

  angleDelta = lerp(angleDeltaMax, angleDeltaMin, ease(abs(t - .5) * 2));

  draw_iter(iterations, width / 2, height * 7 / 8, height / 4, 10, -TAU / 4);
}

void draw_iter(int iters, float x, float y, float length, float weight, float angle) {
  float nx = x + cos(angle) * length;
  float ny = y + sin(angle) * length;
  strokeWeight(weight);
  line(x, y, nx, ny);

  if (iters > 0) {
    draw_iter(iters - 1, nx, ny, length * lengthScale, weight * weightScale, angle + angleDelta);
    draw_iter(iters - 1, nx, ny, length * lengthScale, weight * weightScale, angle - angleDelta);
  }
}
