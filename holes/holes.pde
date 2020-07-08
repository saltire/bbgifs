float[][] cells;
float cellSize;
int cellCount = 20;
int cellMargin = 5;
float cellsAcross = 12.5;

float noiseScale = 2.5;

color bkgdColor = #242624;
color topColor = #484c46;
color[] colors = { #e57272, #e5a667, #e5e567, #a2d86c, #72ace5, #ac72e5 };
int colorSpeed = 3;

void settings() {
  size(750, 750, P3D);
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

  // Set cell size based on how many should fit across the screen.
  cellSize = width * 2 / (sqrt(2) * (cellsAcross + 1));

  result = new int[width * height][3];
}

boolean cell(int x, int y, float chance) {
  return cells[(x + cellCount) % cellCount][(y + cellCount) % cellCount] < chance;
}

boolean cell(int x, int y) {
  return cell(x, y, .5);
}

color phaseColor(float colorOffset) {
  float phasedOffset = colors.length * t * colorSpeed + colorOffset;
  return lerpColor(
    colors[floor(phasedOffset) % colors.length],
    colors[ceil(phasedOffset) % colors.length],
    phasedOffset % 1);
}

void draw_() {
  background(bkgdColor);
  float colorPhase = t * colors.length;

  push();
    translate(width / 2, height / 2, -5000);

    rotateX(TAU / 4 - isoAngle); // upward for isometric projection with Z pointing up
    rotateZ(TAU / 8); // 45 degrees counter-clockwise

    scale(cellSize);

    // animation offsets
    int cellOffset = floor(cellCount * t);
    float thisCellOffset = (cellCount * t) % 1;

    translate(-cellCount / 2 - thisCellOffset, -cellCount / 2 - thisCellOffset);

    drawPlanes(cellOffset);
    drawPlants(cellOffset);
  pop();
}
