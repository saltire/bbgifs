int W = 540;
int N = 200;
float x = 0;
float y = 0;
float t = 0;

void setup() {
  size(540, 540);
  noStroke();
}

void draw() {
  clear();
  for (int i = 0; i < N; i++) {
    for (int j = 0; j < N; j++) {
      float u = sin(i + y) + sin(i + x);
      float v = cos(i + y) + cos(i + x);
      x = u + t;
      y = v;
      fill(j, i, 150);
      circle(u * N / 2 + W / 2, y * N / 2 + W / 2, sin(j));
    }
  }
  t += .06;
}
