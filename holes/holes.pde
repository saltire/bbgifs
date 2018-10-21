// True to save image files.
boolean recording = false;
// If not recording, true to control animation with mouse; false to play on loop.
boolean mouseControl = false;

// Target frame count, and thus speed, for the recorded animation.
int numFrames = 300;
// Number of samples to take per frame when recording.
// Each frame will be an average of these. A higher value gives more of a motion blur effect.
int samplesPerFrame = 4;
// Time period, in frames, over which to spread out the samples.
float shutterAngle = .6;

void setup() {
  size(750, 750, P3D);
  pixelDensity(recording ? 1 : 2);
  smooth(8);
  ortho();
  noiseSeed(2);
  noiseDetail(10, .5);
  ellipseMode(RADIUS);

  // Pregenerate Perlin noise values for each cell.
  cells = new float[cellCount][cellCount];
  for (int x = 0; x < cellCount; x++) {
    for (int y = 0; y < cellCount; y++) {
      cells[x][y] = tilingNoise(norm(x, 0, cellCount), norm(y, 0, cellCount), noiseScale);
    }
  }

  result = new int[width * height][3];
}

float[][] cells;
int cellCount = 20;
float cellSize = 90;
float noiseScale = 2.5;
int arcVertices = 10;
color bkgdColor = #242624;
color topColor = #484c46;
color[] colors = { #e57272, #e5a667, #e5e567, #a2d86c, #72ace5, #ac72e5 };
float planeOffset = 12;
float colorSpeed = 3;

boolean cell(int x, int y, float chance) {
  return cells[(x + cellCount) % cellCount][(y + cellCount) % cellCount] < chance;
}

boolean cell(int x, int y) {
  return cell(x, y, .5);
}

void drawGround(boolean lc, boolean ltc, boolean tc) {
  push();
    noStroke();
    if (!lc && !ltc && !tc) {
      beginShape();
        vertex(0, -.5);
        vertex(0, 0);
        vertex(-.5, 0);
        for (int i = 0; i <= arcVertices; i++) {
          float pos = i / float(arcVertices) * TAU / 4;
          vertex(-.5 * cos(pos), -.5 * sin(pos));
        }
      endShape();
    }
    else {
      rect(-.5, -.5, .5, .5);
    }
  pop();

  push();
    noFill();
    if (!lc && !ltc && !tc) {
      arc(0, 0, .5, .5, TAU / 2, TAU * 3 / 4);
    }
    else {
      if (!lc && !ltc) {
        line(-.5, 0, -.5, -.5);
      }
      if (!ltc && !tc) {
        line(-.5, -.5, 0, -.5);
      }
    }
  pop();
}

void drawHole(boolean lc, boolean ltc, boolean tc) {
  if (lc && tc) {
    push();
      beginShape();
        noStroke();
        vertex(-.5, 0);
        vertex(-.5, -.5);
        vertex(0, -.5);
        for (int i = 0; i <= arcVertices; i++) {
          float pos = i / float(arcVertices) * TAU / 4;
          vertex(-.5 * sin(pos), -.5 * cos(pos));
        }
      endShape();
    pop();

    push();
      noFill();
      arc(0, 0, .5, .5, TAU / 2, TAU * 3 / 4);
    pop();
  }
}

void drawPlane(int cellOffset) {
  for (int x = 0; x < cellCount; x++) {
    for (int y = 0; y < cellCount; y++) {
      push();
        translate(x, y);

        int cx = x + cellOffset;
        int cy = y + cellOffset;

        if (cell(cx, cy)) {
          drawGround(cell(cx - 1, cy), cell(cx - 1, cy - 1), cell(cx, cy - 1));
          rotateZ(TAU / 4);
          drawGround(cell(cx, cy - 1), cell(cx + 1, cy - 1), cell(cx + 1, cy));
          rotateZ(TAU / 4);
          drawGround(cell(cx + 1, cy), cell(cx + 1, cy + 1), cell(cx, cy + 1));
          rotateZ(TAU / 4);
          drawGround(cell(cx, cy + 1), cell(cx - 1, cy + 1), cell(cx - 1, cy));
          rotateZ(TAU / 4);
        }
        else {
          drawHole(cell(cx - 1, cy), cell(cx - 1, cy - 1), cell(cx, cy - 1));
          rotateZ(TAU / 4);
          drawHole(cell(cx, cy - 1), cell(cx + 1, cy - 1), cell(cx + 1, cy));
          rotateZ(TAU / 4);
          drawHole(cell(cx + 1, cy), cell(cx + 1, cy + 1), cell(cx, cy + 1));
          rotateZ(TAU / 4);
          drawHole(cell(cx, cy + 1), cell(cx - 1, cy + 1), cell(cx - 1, cy));
          rotateZ(TAU / 4);
        }
      pop();
    }
  }
}

int fronds = 5;
int points = 10;
float frondLength = 60;
float frondWidth = 8;
float frondSpread = TAU / 36;
float frondPhaseVar = 3;
float frondWaveAmp = .1;
float frondWaveFreq = .75;
float frondWaveSpeed = 15;

void drawFrond(float phase, color fillColor) {
  float x, y, r;
  float[] xs = new float[points];
  float[] ys = new float[points];

  for (int i = 0; i < points; i++) {
    x = (float)i / (points - 1);
    y = sin((TAU * t * frondWaveSpeed) - (TAU * x * frondWaveFreq) + phase) * frondWaveAmp;
    r = lerp(0, frondLength, x);

    xs[i] = r * cos(y);
    ys[i] = r * sin(y);
  }

  // push();
  //   noFill();
  //   stroke(fillColor);
  //   strokeWeight(frondWidth);
  //   beginShape();
  //     for (int i = 0; i < points; i++) {
  //       vertex(xs[i], ys[i]);
  //     }
  //   endShape();
  // pop();

  push();
    stroke(topColor);
    fill(fillColor);
    arc(xs[0], ys[0], frondWidth / 2, frondWidth / 2, TAU / 4, TAU * 3 / 4);
    arc(xs[points - 1], ys[points - 1], frondWidth / 2, frondWidth / 2, -TAU / 4, TAU / 4);
  pop();

  push();
    noStroke();
    fill(fillColor);
    beginShape(TRIANGLE_STRIP);
      for (int i = 0; i < points; i++) {
        vertex(xs[i], ys[i] - frondWidth / 2);
        vertex(xs[i], ys[i] + frondWidth / 2);
      }
    endShape();
  pop();

  push();
    stroke(topColor);
    noFill();
    beginShape();
      for (int i = 0; i < points; i++) {
        vertex(xs[i], ys[i] - frondWidth / 2);
      }
    endShape();
    beginShape();
      for (int i = 0; i < points; i++) {
        vertex(xs[i], ys[i] + frondWidth / 2);
      }
    endShape();
  pop();
}

void drawPlant() {
  for (int f = 0; f < fronds; f++) {
    push();
      float frondAngle = (f - (fronds - 1) / 2) * frondSpread;
      rotateZ(-TAU / 4 + frondAngle);
      // Move closer to the camera.
      // Using a multiple of f because apparently f isn't enough at some distances.
      translate(0, 0, f * 100);

      drawFrond(-frondAngle * frondPhaseVar, phaseColor(f));
    pop();
  }
}

float flowerSize = 15;
float petalSize = 10;

void drawPetals(int count, float radius, float colorOffset) {
  for (int p = 0; p < count; p++) {
    push();
      fill(phaseColor(p * 6 / count + colorOffset));
      rotateZ(-TAU * p / count);
      ellipse(radius, 0, petalSize / 2, petalSize / 2);
    pop();
  }
}

void drawFlower(boolean large) {
  push();
    translate(0, 0, 100);

    if (large) {
      drawPetals(6, flowerSize, 0);
      push();
        translate(0, 0, 20);
        rotateZ(-TAU / 12);
        drawPetals(6, flowerSize, .5);
      pop();
    }

    rotateZ(TAU / 6);
    translate(0, 0, 40);
    drawPetals(3, flowerSize / 2, 0);
    push();
      translate(0, 0, 20);
      rotateZ(-TAU / 6);
      drawPetals(3, flowerSize / 2, .5);
    pop();

    translate(0, 0, 40);
    fill(phaseColor(0));
    ellipse(0, 0, petalSize / 2, petalSize / 2);
  pop();
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

    int cellOffset = floor(cellCount * t);
    float thisCellOffset = (cellCount * t) % 1;

    translate(-cellCount / 2 - thisCellOffset, -cellCount / 2 - thisCellOffset);

    for (int p = 0; p <= colors.length; p++) {
      push();
        fill(p == 0 ? topColor : phaseColor(colors.length - p));
        stroke(topColor);
        strokeWeight(1 / cellSize);
        translate(0, 0, -planeOffset * p / cellSize);
        drawPlane(cellOffset);
      pop();
    }

    // draw plants
    for (int x = 0; x < cellCount; x++) {
      for (int y = 0; y < cellCount; y++) {
        int cx = x + cellOffset;
        int cy = y + cellOffset;

        push();
          translate(x, y);

          // reset rotation and scale
          rotateZ(-TAU / 8);
          rotateX(-TAU / 4 + isoAngle);
          translate(0, 0, x + y);
          scale(1 / cellSize);

          if (cell(cx, cy, .31)) {
            drawPlant();
          }
          else if (cell(cx, cy, .35)) {
            drawFlower(true);
          }
          else if (cell(cx, cy, .4)) {
            drawFlower(false);
          }
        pop();
      }
    }
  pop();
}
