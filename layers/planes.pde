int arcVertices = 10;
float left = TAU / 2;
float topleft = TAU * 5 / 8;
float top = TAU * 3 / 4;

void drawPlane(float level) {
  for (int x = 0; x < cellCount; x++) {
    for (int y = 0; y < cellCount; y++) {
      push();
        translate(x, y);

        int cx = x;
        int cy = y;

        // Draw each of the four corners of the cell, in order NW, NE, SE, SW.
        if (cell(cx, cy, level)) {
          drawGround(cell(cx - 1, cy, level), cell(cx - 1, cy - 1, level), cell(cx, cy - 1, level), 0);
          rotateZ(TAU / 4);
          drawGround(cell(cx, cy - 1, level), cell(cx + 1, cy - 1, level), cell(cx + 1, cy, level), 1);
          rotateZ(TAU / 4);
          drawGround(cell(cx + 1, cy, level), cell(cx + 1, cy + 1, level), cell(cx, cy + 1, level), 2);
          rotateZ(TAU / 4);
          drawGround(cell(cx, cy + 1, level), cell(cx - 1, cy + 1, level), cell(cx - 1, cy, level), 3);
          rotateZ(TAU / 4);
        }
        else {
          drawHole(cell(cx - 1, cy, level), cell(cx - 1, cy - 1, level), cell(cx, cy - 1, level), 0);
          rotateZ(TAU / 4);
          drawHole(cell(cx, cy - 1, level), cell(cx + 1, cy - 1, level), cell(cx + 1, cy, level), 1);
          rotateZ(TAU / 4);
          drawHole(cell(cx + 1, cy, level), cell(cx + 1, cy + 1, level), cell(cx, cy + 1, level), 2);
          rotateZ(TAU / 4);
          drawHole(cell(cx, cy + 1, level), cell(cx - 1, cy + 1, level), cell(cx - 1, cy, level), 3);
          rotateZ(TAU / 4);
        }
      pop();
    }
  }
}

void drawGround(boolean lc, boolean ltc, boolean tc, int corner) {
  push();
    noStroke();
    if (!lc && !ltc && !tc) {
      // Fill top of cylinder.
      arc(0, 0, .5, .5, left, top);

      // Fill sides of cylinder.
      if (corner == 1) { // NE
        beginShape();
          vertex(sin(topleft) * .5, cos(topleft) * .5, 0);
          for (int i = arcVertices / 2; i <= arcVertices; i++) {
            float pos = i / float(arcVertices) * TAU / 4;
            vertex(-.5 * cos(pos), -.5 * sin(pos), -layerHeight);
          }
          vertex(0, -.5, 0);
        endShape();
      }
      else if (corner == 2) { // SE
        beginShape();
          vertex(-.5, 0, 0);
          for (int i = 0; i <= arcVertices; i++) {
            float pos = i / float(arcVertices) * TAU / 4;
            vertex(-.5 * cos(pos), -.5 * sin(pos), -layerHeight);
          }
          vertex(0, -.5, 0);
        endShape();
      }
      else if (corner == 3) { // SW
        beginShape();
          vertex(-.5, 0, 0);
          for (int i = 0; i < arcVertices / 2; i++) {
            float pos = i / float(arcVertices) * TAU / 4;
            vertex(-.5 * cos(pos), -.5 * sin(pos), -layerHeight);
          }
          vertex(sin(topleft) * .5, cos(topleft) * .5, 0);
        endShape();
      }
    }
    else {
      // Fill top of box.
      rect(-.5, -.5, .5, .5);

      // Fill sides of box.
      if (!lc && !ltc && (corner == 2 || corner == 3)) {
        beginShape();
          vertex(-.5, 0, 0);
          vertex(-.5, -.5, 0);
          vertex(-.5, -.5, -layerHeight);
          vertex(-.5, 0, -layerHeight);
        endShape();
      }
      if (!ltc && !tc && (corner == 1 || corner == 2)) {
        beginShape();
          vertex(0, -.5, 0);
          vertex(-.5, -.5, 0);
          vertex(-.5, -.5, -layerHeight);
          vertex(0, -.5, -layerHeight);
        endShape();
      }
    }
  pop();

  push();
    noFill();
    if (!lc && !ltc && !tc) {
      // Stroke top of cylinder.
      arc(0, 0, .5, .5, left, top);

      // Stroke sides and bottom of cylinder.
      if (corner == 1) { // NE
        line(sin(topleft) * .5, cos(topleft) * .5, 0,
          sin(topleft) * .5, cos(topleft) * .5, -layerHeight);
        push();
          translate(0, 0, -layerHeight);
          arc(0, 0, .5, .5, topleft, top);
        pop();
      }
      else if (corner == 2) { // SE
        push();
          translate(0, 0, -layerHeight);
          arc(0, 0, .5, .5, left, top);
        pop();
      }
      else if (corner == 3) { // SW
        line(sin(topleft) * .5, cos(topleft) * .5, 0,
          sin(topleft) * .5, cos(topleft) * .5, -layerHeight);
        push();
          translate(0, 0, -layerHeight);
          arc(0, 0, .5, .5, left, topleft);
        pop();
      }
    }
    else {
      // Stroke top and bottom of box.
      if (!lc && !ltc) {
        line(-.5, 0, -.5, -.5);
        if (corner == 2 || corner == 3) {
          line(-.5, 0, -layerHeight, -.5, -.5, -layerHeight);
        }
      }
      if (!ltc && !tc) {
        line(-.5, -.5, 0, -.5);
        if (corner == 1 || corner == 2) {
          line(-.5, -.5, -layerHeight, 0, -.5, -layerHeight);
        }
      }
    }
  pop();
}

void drawHole(boolean lc, boolean ltc, boolean tc, int corner) {
  if (lc && tc) {
    push();
      noStroke();

      if (corner == 0) { // NW
        // Fill top and sides of inner curve.
        beginShape();
          vertex(-.5, 0, 0);
          vertex(-.5, -.5, 0);
          vertex(-.5, -.5, -layerHeight);
          vertex(-.5, 0, -layerHeight);
        endShape();
        beginShape();
          vertex(0, -.5, 0);
          vertex(-.5, -.5, 0);
          vertex(-.5, -.5, -layerHeight);
          vertex(0, -.5, -layerHeight);
        endShape();
        push();
          translate(0, 0, -layerHeight + .01);
          beginShape();
            vertex(-.5, 0);
            vertex(-.5, -.5);
            vertex(0, -.5);
            for (int i = 0; i <= arcVertices; i++) {
              float pos = i / float(arcVertices) * TAU / 4;
              vertex(-.5 * sin(pos), -.5 * cos(pos));
            }
          endShape();
        pop();
      }
      else if (corner == 2) { // SE
        // Fill top of inner curve.
        beginShape();
          vertex(-.5, 0);
          vertex(-.5, -.5);
          vertex(0, -.5);
          for (int i = 0; i <= arcVertices; i++) {
            float pos = i / float(arcVertices) * TAU / 4;
            vertex(-.5 * sin(pos), -.5 * cos(pos));
          }
        endShape();
      }
      else { // NE, SQ
        // Fill top and sides of inner curve.
        beginShape();
          vertex(-.5, 0);
          vertex(-.5, -.5);
          vertex(0, -.5);
        endShape();
      }
    pop();

    push();
      // Stroke top of inner curve.
      noFill();
      arc(0, 0, .5, .5, left, top);
      if (corner == 0) { // NW
        push();
          translate(0, 0, -layerHeight);
          arc(0, 0, .5, .5, left, top);
        pop();
      }
    pop();
  }
}
