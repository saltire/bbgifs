// True to save image files.
boolean recording = false;
// If not recording, true to control animation with mouse; false to play on loop.
boolean mouseControl = false;

// Target frame count, and thus speed, for the recorded animation.
int numFrames = 60;
// Number of samples to take per frame when recording.
// Each frame will be an average of these. A higher value gives more of a motion blur effect.
int samplesPerFrame = 4;
// Time period, in frames, over which to spread out the samples.
float shutterAngle = .3;


float[][] cells;
int cellCount = 60;
float cellsAcross = 30;
float cellSize;

int layerCount = 21;
float layerHeight = .5; // relative to cell size

float noiseScale = 1.5;

color[] colors = { #0E0026, #0E0026, #46104C, #8C1E47, #CC5D28, #FFBB00, #FFBB00 };
// color[] colors = { #0e0613, #0e0613, #3d1c37, #64284a, #bd4c24, #ff9d1e, #ff9d1e };

void setup() {
  size(750, 750, P3D);
  pixelDensity(recording ? 1 : 2);
  smooth(8);
  ortho(-width / 2, width / 2, -height / 2, height / 2, -10000, 10000);
  ellipseMode(RADIUS);

  // Pregenerate Perlin noise values for each cell.
  noiseSeed(2);
  noiseDetail(10, .5);
  cells = new float[cellCount][cellCount];
  for (int x = 0; x < cellCount; x++) {
    for (int y = 0; y < cellCount; y++) {
      cells[x][y] = tilingNoise(norm(x, 0, cellCount), norm(y, 0, cellCount), noiseScale);
    }
  }

  cellSize = width * 2 / (sqrt(2) * (cellsAcross + 1));

  result = new int[width * height][3];
}

void draw_() {
  background(0);

  translate(width / 2, height / 2, -5000);
  rotateX(TAU / 4 - isoAngle); // upward for isometric projection with Z pointing up
  rotateZ(TAU / 8); // 45 degrees counter-clockwise

  scale(cellSize);
  strokeWeight(.5 / cellSize);
  translate(-cellCount / 2, -cellCount / 2);

  for (int l = 0; l < layerCount; l++) {
    push();
      translate(0, 0, l * layerHeight);
      float level = norm(l + 1, 0, layerCount + 1);
      stroke(color(255, level * level * 255));
      fill(getColor(level));
      drawPlane(1 - level);
    pop();
  }
}

boolean cell(int x, int y, float chance) {
  return cells[(x + cellCount) % cellCount][(y + cellCount) % cellCount] < chance;
}

boolean cell(int x, int y) {
  return cell(x, y, .5);
}

color getColor(float colorValue) {
  float scaledValue = lerp(0, colors.length - 1, ease(colorValue, 1 + sin(TAU * t) * .5));
  return lerpColor(colors[floor(scaledValue)], colors[ceil(scaledValue)], scaledValue % 1);
}
