int arcVertices = 10;

void drawPlane(float level) {
  for (int x = 0; x < cellCount; x++) {
    for (int y = 0; y < cellCount; y++) {
      push();
        translate(x, y);

        int cx = x;
        int cy = y;

        if (cell(cx, cy, level)) {
          drawGround(cell(cx - 1, cy, level), cell(cx - 1, cy - 1, level), cell(cx, cy - 1, level));
          rotateZ(TAU / 4);
          drawGround(cell(cx, cy - 1, level), cell(cx + 1, cy - 1, level), cell(cx + 1, cy, level));
          rotateZ(TAU / 4);
          drawGround(cell(cx + 1, cy, level), cell(cx + 1, cy + 1, level), cell(cx, cy + 1, level));
          rotateZ(TAU / 4);
          drawGround(cell(cx, cy + 1, level), cell(cx - 1, cy + 1, level), cell(cx - 1, cy, level));
          rotateZ(TAU / 4);
        }
        else {
          drawHole(cell(cx - 1, cy, level), cell(cx - 1, cy - 1, level), cell(cx, cy - 1, level));
          rotateZ(TAU / 4);
          drawHole(cell(cx, cy - 1, level), cell(cx + 1, cy - 1, level), cell(cx + 1, cy, level));
          rotateZ(TAU / 4);
          drawHole(cell(cx + 1, cy, level), cell(cx + 1, cy + 1, level), cell(cx, cy + 1, level));
          rotateZ(TAU / 4);
          drawHole(cell(cx, cy + 1, level), cell(cx - 1, cy + 1, level), cell(cx - 1, cy, level));
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
