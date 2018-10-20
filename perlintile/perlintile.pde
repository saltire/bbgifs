int cellSize = 8;
int tileSize = 512;

float baseR = 2; // radius of torus to center of cross-section
float baser = 1; // radius of cross-section

// x and y should be between 0 and 1.
float tilingNoise(float x, float y, float scale) {
  float R = baseR * scale;
  float r = baser * scale;

  // Calculate the 3d coordinates of x,y on the surface of a torus.
  // Offset the torus so its corner touches origin instead of its center.
  // This is because the noise() function seems to be mirrored along all its axes.
  float xx = sin(x * TAU) * (R + sin(y * TAU) * r) + R;
  float yy = cos(x * TAU) * (R + sin(y * TAU) * r) + R;
  float zz = cos(y * TAU) * r + r;
  return noise(xx, yy, zz);
}

float tilingNoise(float x, float y) {
  return tilingNoise(x, y, 1);
}

void setup() {
  size(1024, 1024);
  noStroke();
  noiseDetail(4, .75);

  for (int x = 0; x < width; x += cellSize) {
    for (int y = 0; y < height; y += cellSize) {
      float tx = norm(x, 0, tileSize);
      float ty = norm(y, 0, tileSize);
      fill(tilingNoise(tx, ty, .5) * 255);
      rect(x, y, cellSize, cellSize);
    }
  }
}
