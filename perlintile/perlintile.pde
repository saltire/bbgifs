int cellSize = 8;
int tileSize = 512;

float baseR = 2; // radius of torus to center of cross-section
float baser = 1; // radius of cross-section

float noiseScale = .5;

int numFrames = 100;
float offsetRadius = .3;

// u and v should be between 0 and 1.
float tilingNoise(float u, float v) {
  return tilingNoise(u, v, 0, 0, 0, noiseScale);
}

float tilingNoise(float u, float v, float scale) {
  return tilingNoise(u, v, 0, 0, 0, scale);
}

float tilingNoise(float u, float v, float ox, float oy, float oz) {
  return tilingNoise(u, v, ox, oy, oz, noiseScale);
}

float tilingNoise(float u, float v, float ox, float oy, float oz, float scale) {
  float R = baseR * scale;
  float r = baser * scale;

  // Calculate the 3d coordinates of u,v on the surface of a torus.
  // Offset the torus so its corner touches origin instead of its center.
  // This is because the noise() function seems to be mirrored along all its axes.
  float x = sin(u * TAU) * (R + sin(v * TAU) * r) + R;
  float y = cos(u * TAU) * (R + sin(v * TAU) * r) + R;
  float z = cos(v * TAU) * r + r;
  return noise(x + ox, y + oy, z + oz);
}

void setup() {
  size(1024, 1024);
  noStroke();
  noiseDetail(4, .75);
}

void draw() {
  // Offset the torus in a circular motion along all three axes,
  // to animate the noise in a loop.
  float t = (float)(frameCount % numFrames) / numFrames;
  float ox = (sin(t * TAU) + 1) * offsetRadius;
  float oy = (cos(t * TAU) + 1) * offsetRadius;
  float oz = (sin((t + .125) * TAU) + 1) * offsetRadius;

  for (int u = 0; u < width; u += cellSize) {
    for (int v = 0; v < height; v += cellSize) {
      float tu = (float)u / tileSize;
      float tv = (float)v / tileSize;
      fill(tilingNoise(tu, tv, ox, oy, oz, noiseScale) * 255);
      rect(u, v, cellSize, cellSize);
    }
  }
}
