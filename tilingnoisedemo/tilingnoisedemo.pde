int numFrames = 100;

int cellSize = 8;
int tileSize = 512;

void setup() {
  size(1024, 1024);
  noStroke();
  noiseDetail(4, .75);
  noiseScale = .5;
  offsetRadius = .3;
}

void draw() {
  float t = (float)(frameCount % numFrames) / numFrames;
  float[] offsets = getOffsets(t);

  for (int u = 0; u < width; u += cellSize) {
    for (int v = 0; v < height; v += cellSize) {
      float tu = (float)u / tileSize;
      float tv = (float)v / tileSize;
      fill(tilingNoise(tu, tv, offsets) * 255);
      rect(u, v, cellSize, cellSize);
    }
  }
}
