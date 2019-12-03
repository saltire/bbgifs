int iterations = 15;

int segments = 10;
int bezierSegmentIter = 6;
int bezierIter = 10;

float angleDeltaMin = 0;
float angleDeltaMax = TAU / 4;
float angleDelta;

// float scale = 0.6182;
float lengthScale = 1 / 1.456;

float weightScale = 1 / 1.333;

void settings() {
  size(800, 800);
}

void draw_() {
  background(255);
  stroke(0);

  angleDelta = lerp(angleDeltaMax, angleDeltaMin, ease(abs(t - .5) * 2));

  PVector start = new PVector(width / 2, height * 7 / 8);
  float initialAngle = -TAU / 4;
  float initialWeight = 15;

  draw_iter(1, start, start, height / 4, initialWeight, initialAngle);
}

void draw_iter(int iter, PVector lmp, PVector p, float length, float weight, float angle) {
  PVector np = new PVector(p.x + cos(angle) * length, p.y + sin(angle) * length);
  PVector mp = new PVector(lerp(p.x, np.x, .5), lerp(p.y, np.y, .5));
  float nextLength = length * lengthScale;
  float nextWeight = weight * weightScale;

  strokeWeight(weight);
  strokeCap(SQUARE);

  // Vary level of detail for different iterations, for optimization purposes.
  if (iter >= bezierIter) {
    // Just draw a straight line.
    line(p.x, p.y, np.x, np.y);
  }
  // Overlap line and bezier iterations to avoid a gap.
  if (iter <= bezierIter) {
    if (iter > bezierSegmentIter) {
      // Draw a bezier.
      bezier(lmp.x, lmp.y, p.x, p.y, p.x, p.y, mp.x, mp.y);
    }
    else {
      // Draw a bezier in segments, tapering the stroke weight.
      strokeCap(ROUND);
      PVector last = lmp;
      for (int i = 1; i < segments; i++) {
        float j = float(i) / segments;
        PVector v = new PVector(bezierPoint(lmp.x, p.x, p.x, mp.x, j), bezierPoint(lmp.y, p.y, p.y, mp.y, j));
        strokeWeight(lerp(weight, nextWeight, j));
        line(last.x, last.y, v.x, v.y);
        last = v;
      }
      strokeWeight(nextWeight);
      line(last.x, last.y, mp.x, mp.y);
    }
  }

  if (iter < iterations) {
    draw_iter(iter + 1, mp, np, nextLength, nextWeight, angle + angleDelta);
    draw_iter(iter + 1, mp, np, nextLength, nextWeight, angle - angleDelta);
  }
}
