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
float shutterAngle = .6;

void setup() {
  size(750, 750, P3D);
  pixelDensity(recording ? 1 : 2);
  smooth(8);
  ortho();
  noiseSeed(2);
  noiseDetail(10, .5);

  result = new int[width * height][3];
}


int cells = 30;
float cellSize = 50;
float noiseScale = 2;
int arcVertices = 10;
color bkgdColor = #242624;
color topColor = #484c46;
color[] colors = { #e57272, #e5a667, #e5e567, #a2d86c, #72ace5, #ac72e5 };
float planeOffset = 15;

boolean cell(int x, int y, float chance) {
  return tilingNoise(norm(x, 0, cells), norm(y, 0, cells), noiseScale) < chance;
}

boolean cell(int x, int y) {
  return cell(x, y, .5);
}

void drawGround(boolean lc, boolean ltc, boolean tc) {
  push();
    noStroke();
    if (!lc && !ltc && !tc) {
      beginShape();
        vertex(0, -1);
        vertex(0, 0);
        vertex(-1, 0);
        for (int i = 0; i <= arcVertices; i++) {
          float pos = i / float(arcVertices) * TAU / 4;
          vertex(-cos(pos), -sin(pos));
        }
      endShape();
    }
    else {
      rect(-1, -1, 1, 1);
    }
  pop();

  push();
    noFill();
    if (!lc && !ltc && !tc) {
      arc(0, 0, 2, 2, TAU / 2, TAU * 3 / 4);
    }
    else {
      if (!lc && !ltc) {
        line(-1, 0, -1, -1);
      }
      if (!ltc && !tc) {
        line(-1, -1, 0, -1);
      }
    }
  pop();
}

void drawHole(boolean lc, boolean ltc, boolean tc) {
  if (lc && tc) {
    push();
      beginShape();
        noStroke();
        vertex(-1, 0);
        vertex(-1, -1);
        vertex(0, -1);
        for (int i = 0; i <= arcVertices; i++) {
          float pos = i / float(arcVertices) * TAU / 4;
          vertex(-sin(pos), -cos(pos));
        }
      endShape();
    pop();

    push();
      noFill();
      arc(0, 0, 2, 2, TAU / 2, TAU * 3 / 4);
    pop();
  }
}

void drawPlane() {
  for (int x = 0; x < cells; x++) {
    for (int y = 0; y < cells; y++) {
      push();
        translate(x * 2, y * 2);

        if (cell(x, y)) {
          drawGround(cell(x - 1, y), cell(x - 1, y - 1), cell(x, y - 1));
          rotateZ(TAU / 4);
          drawGround(cell(x, y - 1), cell(x + 1, y - 1), cell(x + 1, y));
          rotateZ(TAU / 4);
          drawGround(cell(x + 1, y), cell(x + 1, y + 1), cell(x, y + 1));
          rotateZ(TAU / 4);
          drawGround(cell(x, y + 1), cell(x - 1, y + 1), cell(x - 1, y));
          rotateZ(TAU / 4);
        }
        else {
          drawHole(cell(x - 1, y), cell(x - 1, y - 1), cell(x, y - 1));
          rotateZ(TAU / 4);
          drawHole(cell(x, y - 1), cell(x + 1, y - 1), cell(x + 1, y));
          rotateZ(TAU / 4);
          drawHole(cell(x + 1, y), cell(x + 1, y + 1), cell(x, y + 1));
          rotateZ(TAU / 4);
          drawHole(cell(x, y + 1), cell(x - 1, y + 1), cell(x - 1, y));
          rotateZ(TAU / 4);
        }
      pop();
    }
  }
}

int fronds = 5;
int points = 10;
float frondLength = 30;
float frondWidth = 4;
float frondSpread = TAU / 36;
float frondPhaseVar = 3;
float frondWaveAmp = .1;
float frondWaveFreq = .75;
float frondWaveSpeed = 3;

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
    arc(xs[0], ys[0], frondWidth, frondWidth, TAU / 4, TAU * 3 / 4);
    arc(xs[points - 1], ys[points - 1], frondWidth, frondWidth, -TAU / 4, TAU / 4);
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
      translate(0, 0, f);
      drawFrond(-frondAngle * frondPhaseVar, phaseColor(f));
    pop();
  }
}

color phaseColor(int colorIndex) {
  float colorPhase = t * colors.length;
  float phasedIndex = colorIndex + colorPhase;
  return lerpColor(
    colors[floor(phasedIndex) % colors.length],
    colors[ceil(phasedIndex) % colors.length],
    colorPhase % 1);
}

void draw_() {
  background(bkgdColor);
  float colorPhase = t * colors.length;

  push();
    translate(width / 2, height / 2);

    rotateX(TAU / 4 - isoAngle); // upward for isometric projection with Z pointing up
    rotateZ(-TAU / 8); // 45 degrees counter-clockwise

    scale(cellSize / 2);
    translate(-cells + 1, -cells + 1);

    for (int p = 0; p <= colors.length; p++) {
      push();
        fill(p == 0 ? topColor : phaseColor(colors.length - p));
        stroke(topColor);
        strokeWeight(2 / cellSize);
        translate(0, 0, -planeOffset * p / cellSize);
        drawPlane();
      pop();
    }

    // draw plants
    for (int x = 0; x < cells; x++) {
      for (int y = 0; y < cells; y++) {
        if (cell(x, y, .3)) {
          push();
            translate(x * 2, y * 2);

            // reset rotation and scale
            rotateZ(TAU / 8);
            rotateX(-(TAU / 4 - isoAngle));
            scale(2 / cellSize);

            drawPlant();
          pop();
        }
      }
    }
  pop();
}
