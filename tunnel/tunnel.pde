// True to save image files.
boolean recording = false;
// If not recording, true to control animation with mouse; false to play on loop.
boolean mouseControl = false;

// Target frame count, and thus speed, for the recorded animation.
int numFrames = 240;
// Number of samples to take per frame when recording.
// Each frame will be an average of these. A higher value gives more of a motion blur effect.
int samplesPerFrame = 1;
// Time period, in frames, over which to spread out the samples.
float shutterAngle = .3;


float[][][] cells;
int cellCount = 50;

int noiseFrames = 24;

int rings = 30;
int ringSegments = 40;
int segmentVertices = 5;
float ringWidth = 100;
float ringRadius;

color[] colors = { #0E0026, #0E0026, #46104C, #8C1E47, #CC5D28, #FFBB00, #FFBB00 };
// color[] colors = { #0e0613, #0e0613, #3d1c37, #64284a, #bd4c24, #ff9d1e, #ff9d1e };
int colorSpeed = 4;
float colorPulseAmount = .35;


void setup() {
  size(500, 500, P3D);
  pixelDensity(recording ? 1 : 2);
  smooth(8);
  ellipseMode(RADIUS);

  ringRadius = sqrt(width * width + height * height) / 2;

  // Pregenerate Perlin noise values for each cell, and for each frame of noise.
  noiseSeed(2);
  noiseDetail(10, .5);
  noiseScale = 1.5;
  offsetRadius = .2;
  cells = new float[noiseFrames][rings][ringSegments];
  for (int nf = 0; nf < noiseFrames; nf++) {
    cells[nf] = generateCells(rings, ringSegments, (float)nf / noiseFrames);
  }

  result = new int[width * height][3];
}

float[][] generateCells(int xSize, int ySize, float nt) {
  float[] offsets = getOffsets(nt);

  float[][] newCells = new float[xSize][ySize];
  for (int x = 0; x < xSize; x++) {
    for (int y = 0; y < ySize; y++) {
      newCells[x][y] = tilingNoise((float)x / xSize, (float)y / ySize, offsets);
    }
  }
  return newCells;
}

void draw_() {
  background(0);
  translate(width / 2, height / 2);

  // animation offsets
  int ringOffset = floor(rings * t);
  float thisRingOffset = (rings * t) % 1;

  int noiseFrame = floor(noiseFrames * t);
  float noiseFrameOffset = (noiseFrames * t) % 1;

  // stroke(255);
  noStroke();
  for (int r = rings - 1; r >= 0; r--) {
    int cr = (r + ringOffset) % rings;

    push();
      translate(0, 0, (-r + thisRingOffset) * ringWidth);

      float fade = (float)(rings - r) / rings;

      for (int s = 0; s < ringSegments; s++) {
        float cell = cells[noiseFrame][cr][s];
        float nextCell = cells[(noiseFrame + 1) % noiseFrames][cr][s];
        float value = lerp(cell, nextCell, noiseFrameOffset);
        fill(value * 255 * fade);

        beginShape();
          for (int v = 0; v <= segmentVertices; v++) {
            float th = (s + (float)v / segmentVertices) / ringSegments * TAU;
            vertex(sin(th) * ringRadius, cos(th) * ringRadius, 0);
          }
          for (int v = segmentVertices; v >= 0; v--) {
            float th = (s + (float)v / segmentVertices) / ringSegments * TAU;
            vertex(sin(th) * ringRadius, cos(th) * ringRadius, -ringWidth);
          }
        endShape();
      }
    pop();
  }
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
