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
float tileSize = 50;
int arcVertices = 10;
color bkgdColor = #242624;
color topColor = #484c46;
color[] colors = { #e57272, #e5a667, #e5e567, #a2d86c, #72ace5, #ac72e5 };
float planeOffset = 15;

boolean cell(int x, int y, float chance) {
  return 1 - noise(x, y) < chance;
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

    scale(tileSize / 2);
    translate(-cells + 1, -cells + 1);

    for (int p = 0; p <= colors.length; p++) {
      push();
        fill(p == 0 ? topColor : phaseColor(colors.length - p));
        stroke(topColor);
        strokeWeight(2 / tileSize);
        translate(0, 0, -planeOffset * p / tileSize);
        drawPlane();
      pop();
    }

    for (int x = 0; x < cells; x++) {
      for (int y = 0; y < cells; y++) {
        if (cell(x, y, .25)) {
          push();
            translate(x * 2, y * 2);

            // reset rotation and scale
            rotateZ(TAU / 8);
            rotateX(-(TAU / 4 - isoAngle));
            scale(2 / tileSize);

            drawPlant();
          pop();
        }
      }
    }
  pop();
}


////////////////////////////////////////////////////////////////////////////////


int[][] result;
float t, c;

// height of an equilateral triangle with side length 1: 0.8660254
float triHeight = sqrt(3) / 2;
// rotation angle on x-axis for isometric projection: 35.26439 deg
float isoAngle = atan(1 / sqrt(2));

float easeOut(float value) {
  return 1 - sq(1 - value);
}

float ease(float value) {
  return 3 * pow(value, 2) - 2 * pow(value, 3);
}

float ease(float value, float exp) {
  return value < 0.5 ?
    pow(value * 2, exp) / 2 :
    1 - pow((1 - value) * 2, exp) / 2;
}

void push() {
  pushMatrix();
  pushStyle();
}

void pop() {
  popStyle();
  popMatrix();
}

// Clamp/constrain a value between 0 and 1.
float c01(float value) {
  return constrain(value, 0, 1);
}

void draw() {
  // Control the animation with the mouse position on the X-axis.
  if (!recording) {
    if (mouseControl) {
      t = mouseX * 1.0 / width;
      c = mouseY * 1.0 / height;

      if (mousePressed) {
        println(c);
      }
    }
    else {
      t = norm((frameCount - 1) % numFrames, 0, numFrames);
    }

    draw_();
  }
  else {
    // Initialize a pixel buffer.
    for (int i = 0; i < width * height; i++) {
      for (int a = 0; a < 3; a++) {
        result[i][a] = 0;
      }
    }

    c = 0;
    for (int sa = 0; sa < samplesPerFrame; sa++) {
      // For each sample, set the time somewhere between the frame and (frame + shutterAngle).
      t = norm(frameCount - 1 + sa * shutterAngle / samplesPerFrame, 0, numFrames);
      draw_();

      // Add the value of this sample to the result.
      loadPixels();
      for (int i = 0; i < pixels.length; i++) {
        result[i][0] += pixels[i] >> 16 & 0xff;
        result[i][1] += pixels[i] >> 8 & 0xff;
        result[i][2] += pixels[i] & 0xff;
      }
    }

    // Divide the values by the number of samples to get the average.
    // loadPixels(); // not sure if this is necessary
    for (int i = 0; i < pixels.length; i++) {
      pixels[i] = 0xff << 24 |
        int(result[i][0] * 1.0 / samplesPerFrame) << 16 |
        int(result[i][1] * 1.0 / samplesPerFrame) << 8 |
        int(result[i][2] * 1.0 / samplesPerFrame);
    }
    updatePixels();

    // Save frame to disk and exit if finished.
    saveFrame("f###.gif");
    if (frameCount == numFrames) {
      exit();
    }
  }
}
