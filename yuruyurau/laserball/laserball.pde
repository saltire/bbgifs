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
      float r = TAU / N;
      float u = sin(i + y) + sin(r * i + x);
      float v = cos(i + y) + cos(r * i + x);
      x = u + t;
      y = v;
      fill(i, j, 99);
      circle(u * N / 2 + W / 2, y * N / 2 + W / 2, 2);
    }
  }
  t += .1;
}
