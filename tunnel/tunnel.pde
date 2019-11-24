// True to save image files.
boolean recording = false;
// If not recording, true to control animation with mouse; false to play on loop.
boolean mouseControl = false;

// Target frame count, and thus speed, for the recorded animation.
int numFrames = 360;
// Number of samples to take per frame when recording.
// Each frame will be an average of these. A higher value gives more of a motion blur effect.
int samplesPerFrame = 1;
// Time period, in frames, over which to spread out the samples.
float shutterAngle = .3;


float[][][] cells;
int cellCount = 50;

int noiseFrames = 6;
int noiseSpeed = 4;

int rings = 20;
int ringRepeats = 2;
int ringSegments = 20;
int ringRotate = 4; // Should be a factor of the number of rings.
int segmentVertices = 5;
float ringWidth = 500;
float ringRadiusMult = 1.5;
float pointHeight = .4;

float ringRadius;
float segmentAngle;

color[] colors = { #27233A, #27233A, #2C6C75, #319470, #ACECA1, #EAEFD3 };
int colorSpeed = 4;
float colorPulseAmount = 0;


void setup() {
  size(600, 600, P3D);
  pixelDensity(recording ? 1 : 2);
  smooth(8);
  ellipseMode(RADIUS);

  // Set camera field of view and clipping range.
  float fov = TAU / 10;
  float cameraZ = (height / 2) / tan(fov / 2);
  perspective(fov, width / height, cameraZ / 10, cameraZ * 100);

  result = new int[width * height][3];

  // Pregenerate Perlin noise values for each cell, and for each frame of noise.
  noiseSeed(2);
  noiseDetail(10, .5);
  noiseScale = 1.5;
  offsetRadius = .2;
  cells = new float[noiseFrames][rings][ringSegments];
  for (int nf = 0; nf < noiseFrames; nf++) {
    cells[nf] = generateCells(rings, ringSegments, (float)nf / noiseFrames);
  }

  ringRadius = sqrt(width * width + height * height) / 2 * ringRadiusMult;
  segmentAngle = TAU / ringSegments;
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
  background(colors[0]);
  strokeWeight(.5);
  translate(width / 2, height / 2);

  // animation offsets
  int ringOffset = floor(rings * t);
  float thisRingOffset = (rings * t) % 1;

  int noiseFrame = floor(noiseFrames * t * noiseSpeed) % noiseFrames;
  float noiseFrameOffset = (noiseFrames * t * noiseSpeed) % 1;

  int totalRings = rings * ringRepeats;

  for (int repeat = ringRepeats - 1; repeat >= 0; repeat--) {
    for (int r = rings - 1; r >= 0; r--) { // Number of rings away from the camera for this repeat.
      int cr = (r + ringOffset) % rings; // Cell x-value for this ring.
      int rr = r + rings * repeat; // Number of rings away from the camera overall.

      push();
        translate(0, 0, (-rr + thisRingOffset) * ringWidth);
        rotateZ((float)(cr % ringRotate) / ringRotate * segmentAngle);

        float fade = (float)(totalRings - rr) / totalRings;
        float easeFade = easeOut(fade);
        stroke(255, fade * fade * fade * 255 * 0.75);

        for (int s = 0; s < ringSegments; s++) { // Cell y-value for this segment.
          float cell = cells[noiseFrame][cr][s];
          float nextCell = cells[(noiseFrame + 1) % noiseFrames][cr][s];
          float value = lerp(cell, nextCell, noiseFrameOffset);

          push();
            fill(getColor(value * easeFade));
            rotateZ(s * segmentAngle);

            drawSpike(value);
          pop();
        }
      pop();
    }
  }
}

void drawSpike(float value) {
  float pointRadius = (1 - ease(value, 4) * pointHeight) * ringRadius;
  float left = -segmentAngle / 2;
  float right = segmentAngle / 2;

  // back
  beginShape();
    for (int v = segmentVertices; v >= 0; v--) {
      float vAngle = map(v, 0, segmentVertices, left, right);
      vertex(sin(vAngle) * ringRadius, cos(vAngle) * ringRadius, -ringWidth);
    }

    vertex(0, pointRadius, -ringWidth / 2);
  endShape(CLOSE);

  // sides
  beginShape();
    vertex(sin(left) * ringRadius, cos(left) * ringRadius, 0);
    vertex(sin(left) * ringRadius, cos(left) * ringRadius, -ringWidth);
    vertex(0, pointRadius, -ringWidth / 2);
  endShape();
  beginShape();
    vertex(sin(right) * ringRadius, cos(right) * ringRadius, -ringWidth);
    vertex(sin(right) * ringRadius, cos(right) * ringRadius, 0);
    vertex(0, pointRadius, -ringWidth / 2);
  endShape();

  // front
  beginShape();
    for (int v = 0; v <= segmentVertices; v++) {
      float vAngle = map(v, 0, segmentVertices, left, right);
      vertex(sin(vAngle) * ringRadius, cos(vAngle) * ringRadius, 0);
    }

    vertex(0, pointRadius, -ringWidth / 2);
  endShape(CLOSE);
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
