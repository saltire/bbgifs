void settings() {
  size(1080, 1920, P2D);
}

float dw = 150;
float dh = dw / 2;
float gap = 50;
float rh = 100;

float xvar = 400;
float yvar = 300;

float textYvar = 300;

float center;
float ycenter;
PFont font;

color getColor(color[] colors, float value) {
  float colorValue = value * (colors.length - 1);
  return lerpColor(colors[floor(colorValue)], colors[ceil(colorValue)], colorValue % 1);
}

void diamond(float x, float y) {
  beginShape();
  vertex(x, y - dh / 2);
  vertex(x + dw / 2, y);
  vertex(x, y + dh / 2);
  vertex(x - dw / 2, y);
  endShape();
}

void oval(float x, float y, float d) {
  float w = lerp(dw, dh, d);
  float h = lerp(dh, dw, d);
  ellipse(x, y, w, h);
}

void drawShape(float x, float y, float d) {
  // diamond(x, y);
  oval(x, y, d);
}

void drawShapeGrid(float xOffset, float yOffset, float d) {
  float x = center + xOffset * xvar;
  float y = -(1 + yOffset) * yvar;
  int r = 0;

  int wings = ceil(((width / 2) + xvar) / (dw + gap));

  while (y < height + yvar) {
    if ((r % 2) == 0) {
      drawShape(x, y, d);
      for (int i = 1; i <= wings; i++) {
        drawShape(x - (dw + gap) * i, y, d);
        drawShape(x + (dw + gap) * i, y, d);
      }
    }
    else {
      for (int i = 1; i <= wings; i++) {
        drawShape(x - (dw + gap) * (i - 0.5), y, d);
        drawShape(x + (dw + gap) * (i - 0.5), y, d);
      }
    }

    y += rh;
    r += 1;
  }
}

void drawShapes(float t) {
  float c = sin((t + 0.75) * TAU);
  float c01 = norm(c, -1, 1);

  boolean s = cos((t + 0.75) * TAU) > 0;

  push();
    fill(getColor(water, c01));
    drawShapeGrid(s ? c01 - 1 : 1 - c01, c, c01);
  pop();
}

void text(float t) {
  float c = sin((t + 0.75) * TAU);

  push();
    fill(t < 0.5 ? 255 : 0, ease(1 - abs(c), 3) * 255);
    text(t < 0.5 ? "INHALE" : "EXHALE", center, ycenter - c * textYvar);
  pop();
}

void setup_() {
  noStroke();

  center = width / 2 + 0.5;
  ycenter = height / 2 + 0.5;

  // font = createFont("C:\\Users\\Marcus\\AppData\\Local\\Microsoft\\Windows\\Fonts\\PramukhRounded-Semibold.otf", 500);
  font = createFont("PramukhRounded-Semibold", 500);
  textFont(font);
  textAlign(CENTER, CENTER);
}

void draw_() {
  background(0);

  for (float f = 1; f <= numFrames; f++) {
    drawShapes(t + f / numFrames);
  }

  text(t);
}
