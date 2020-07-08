float[][] cells;
int cellCount = 50;
int cellMargin = 5;
float cellsAcross = 30;
float cellSize;

int layerCount = 21;
float layerHeight = .5; // relative to cell size

float noiseScale = 1.5;

color[] colors = { #0E0026, #0E0026, #46104C, #8C1E47, #CC5D28, #FFBB00, #FFBB00 };
// color[] colors = { #0e0613, #0e0613, #3d1c37, #64284a, #bd4c24, #ff9d1e, #ff9d1e };
int colorSpeed = 4;
float colorPulseAmount = .35;

void settings() {
  size(500, 500, P3D);
  pixelDensity(recording ? 1 : 2);
  smooth(8);
}

void setup_() {
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

  // animation offsets
  int cellOffset = floor(cellCount * t);
  float thisCellOffset = (cellCount * t) % 1;

  translate(-cellCount / 2 - thisCellOffset, -cellCount / 2 - thisCellOffset);

  strokeWeight(.5 / cellSize);

  for (int l = 0; l < layerCount; l++) {
    push();
      translate(0, 0, l * layerHeight);
      float level = norm(l + 1, 0, layerCount + 1);
      stroke(color(255, level * level * 255));
      fill(getColor(level));
      drawPlane(1 - level, cellOffset);
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
  // pow() affects brightness; ease() more affects contrast.
  float pulsedValue = pow(colorValue, 1 + sin(TAU * t * colorSpeed) * colorPulseAmount);
  // float pulsedValue = ease(colorValue, 1 + sin(TAU * t * colorSpeed) * colorPulseAmount);

  float scaledValue = lerp(0, colors.length - 1, pulsedValue);
  return lerpColor(
    colors[floor(scaledValue)],
    colors[ceil(scaledValue)],
    scaledValue % 1);
}
