int arcVertices = 10;
float planeOffset;

void drawPlanes(int cellOffset) {
  planeOffset = cellSize / 8;

  for (int p = 0; p <= colors.length; p++) {
    push();
      fill(p == 0 ? topColor : phaseColor(colors.length - p));
      stroke(topColor);
      strokeWeight(1 / cellSize);
      translate(0, 0, -planeOffset * p / cellSize);
      drawPlane(cellOffset);
    pop();
  }
}

void drawPlane(int cellOffset) {
  for (int x = -cellMargin; x < cellCount + cellMargin; x++) {
    for (int y = -cellMargin; y < cellCount + cellMargin; y++) {
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

void drawGround(boolean lc, boolean ltc, boolean tc) {
  push();
    noStroke();
    if (!lc && !ltc && !tc) {
      arc(0, 0, .5, .5, TAU / 2, TAU * 3 / 4);
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
