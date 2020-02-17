int W = 540;
int N = 200;
float x = 0;
float y = 0;
float t = 9;

void setup() {
  size(540, 540);
  noStroke();
  // blendMode(ADD);
}

void draw() {
  clear();
  for (int i = 0; i < N; i++) {
    for (int j = 0; j < N; j++) {
      float u = sin(i + y) + sin(j / N * PI + x);
      float v = cos(i + y) + cos(j / N * PI + x);
      x = u + t;
      y = v + t;
      fill(i, j, 99);
      // fill(i, j, 99, 50);
      circle(u * N / 2 + W / 2, v * N / 2 + W / 2, 2);
    }
  }
  t += .1;
}
