int fronds = 5;
int frondVertices = 10;
float frondSpread = TAU / 36;
float frondPhaseVar = 3;
float frondWaveAmp = .1;
float frondWaveFreq = .75;
float frondWaveSpeed = 15;
float frondLength;
float frondWidth;

float flowerSize;
float petalSize;

void drawPlants(int cellOffset) {
  frondLength = cellSize * 1.2;
  frondWidth = cellSize / 10;

  flowerSize = cellSize / 6;
  petalSize = cellSize / 10;

  for (int x = -cellMargin; x < cellCount + cellMargin; x++) {
    for (int y = -cellMargin; y < cellCount + cellMargin; y++) {
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
          drawFern();
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
}

void drawFern() {
  for (int f = 0; f < fronds; f++) {
    push();
      float frondAngle = (f - (fronds - 1) / 2) * frondSpread;
      rotateZ(-TAU / 4 + frondAngle);
      // Move closer to the camera.
      // Using a multiple of f because apparently f isn't enough at some distances.
      translate(0, 0, f * 50);

      drawFrond(-frondAngle * frondPhaseVar, phaseColor(f));
    pop();
  }
}

void drawFrond(float phase, color fillColor) {
  float x, y, r;
  float[] xs = new float[frondVertices];
  float[] ys = new float[frondVertices];

  for (int i = 0; i < frondVertices; i++) {
    x = (float)i / (frondVertices - 1);
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
  //     for (int i = 0; i < frondVertices; i++) {
  //       vertex(xs[i], ys[i]);
  //     }
  //   endShape();
  // pop();

  push();
    stroke(topColor);
    fill(fillColor);
    arc(xs[0], ys[0], frondWidth / 2, frondWidth / 2, TAU / 4, TAU * 3 / 4);
    arc(xs[frondVertices - 1], ys[frondVertices - 1], frondWidth / 2, frondWidth / 2,
      -TAU / 4, TAU / 4);
  pop();

  push();
    noStroke();
    fill(fillColor);
    beginShape(TRIANGLE_STRIP);
      for (int i = 0; i < frondVertices; i++) {
        vertex(xs[i], ys[i] - frondWidth / 2);
        vertex(xs[i], ys[i] + frondWidth / 2);
      }
    endShape();
  pop();

  push();
    stroke(topColor);
    noFill();
    beginShape();
      for (int i = 0; i < frondVertices; i++) {
        vertex(xs[i], ys[i] - frondWidth / 2);
      }
    endShape();
    beginShape();
      for (int i = 0; i < frondVertices; i++) {
        vertex(xs[i], ys[i] + frondWidth / 2);
      }
    endShape();
  pop();
}

void drawFlower(boolean large) {
  push();
    translate(0, 0, 100);
    stroke(topColor);

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

void drawPetals(int count, float radius, float colorOffset) {
  for (int p = 0; p < count; p++) {
    push();
      fill(phaseColor(p * 6 / count + colorOffset));
      rotateZ(-TAU * p / count);
      ellipse(radius, 0, petalSize / 2, petalSize / 2);
    pop();
  }
}
