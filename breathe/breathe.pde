void settings() {
  size(1080, 1920, P2D);
}

float axlong = 100;
float axshort = 100;

float xgap = 40;
float ygap = 150;

float xvar = 100;
float yvar = 100;

float center;
float ycenter;

PFont font;
String inText = "BREATHE IN";
String outText = "BREATHE OUT";
float fontSize = 380;
float textYvar = 380;

PGraphics textBuf;

void setup_() {
  noStroke();

  center = width / 2 + 0.5;
  ycenter = height / 2 + 0.5;

  font = createFont("C:\\Users\\Marcus\\AppData\\Local\\Microsoft\\Windows\\Fonts\\PramukhRounded-Semibold.otf",
    fontSize);
  // font = createFont("PramukhRounded-Semibold", 500);
  textFont(font);
  textAlign(CENTER, CENTER);

  textBuf = createGraphics(width, height);
}

color getColor(color[] colors, float value) {
  float colorValue = value * (colors.length - 1);
  return lerpColor(colors[floor(colorValue)], colors[ceil(colorValue)], colorValue % 1);
}

void diamond(float x, float y, float d) {
  float w = lerp(axlong, axshort, d);
  float h = lerp(axshort, axlong, d);

  beginShape();
  vertex(x, y - h / 2);
  vertex(x + w / 2, y);
  vertex(x, y + h / 2);
  vertex(x - w / 2, y);
  endShape();
}

void oval(float x, float y, float d) {
  float w = lerp(axlong, axshort, d);
  float h = lerp(axshort, axlong, d);
  ellipse(x, y, w, h);
}

void drawShape(float x, float y, float d) {
  // diamond(x, y, d);
  oval(x, y, d);
}

void drawShapeGrid(float xOffset, float yOffset, float d) {
  float x = center + xOffset * xvar;
  float y = -(1 + yOffset) * yvar;
  int r = 0;

  int wings = ceil(((width / 2) + xvar) / (axlong + xgap));

  while (y < height + yvar) {
    if ((r % 2) == 0) {
      drawShape(x, y, d);
      for (int i = 1; i <= wings; i++) {
        drawShape(x - (axlong + xgap) * i, y, d);
        drawShape(x + (axlong + xgap) * i, y, d);
      }
    }
    else {
      for (int i = 1; i <= wings; i++) {
        drawShape(x - (axlong + xgap) * (i - 0.5), y, d);
        drawShape(x + (axlong + xgap) * (i - 0.5), y, d);
      }
    }

    y += ygap;
    r += 1;
  }
}

void drawShapes(float t) {
  float c = sin((t + 0.75) * TAU);
  float c01 = norm(c, -1, 1);

  boolean s = cos((t + 0.75) * TAU) > 0;

  // sideways zigzag
  // float ox = s ? c01 - 1 : 1 - c01;
  // float oy = c;
  // float d = c01;

  // clockwise circle
  float phase = s ? c01 * 1.5 + 0.5 : (1 - c01) * 1.5 + 1;
  float ox = sin(phase * TAU);
  float oy = cos(phase * TAU);
  float d = 0.5;

  push();
    fill(getColor(sepiapurple, c01));
    drawShapeGrid(ox, oy, d);
  pop();
}

void drawText(float t) {
  float c = sin((t + 0.75) * TAU);

  float a = ease(1 - abs(c), 5);

  // simple fade
  // push();
  //   fill(t < 0.5 ? 255 : 0, a * 255);
  //   text(t < 0.5 ? inText : outText, center, ycenter - c * textYvar);
  // pop();

  // trails with fade
  textBuf.beginDraw();
  textBuf.clear();
  textBuf.textFont(font);
  textBuf.textAlign(CENTER, CENTER);
  color[] textcolors = sepiapurple;
  for (int f = textcolors.length; f >= 0; f--) {
    float tt = t - float(f) / numFrames;
    float cc = sin((tt + 0.75) * TAU);

    float aa = map(f, 10, 0, 0, 255);

    textBuf.fill(f == 0 ? #ffffff : textcolors[textcolors.length - f], aa);
    textBuf.text(t < 0.5 ? inText : outText, center, ycenter - cc * textYvar);
  }
  textBuf.endDraw();
  push();
    tint(255, a * 255);
    image(textBuf, 0, 0);
  pop();
}

void draw_() {
  background(0);

  for (float f = 1; f <= numFrames; f++) {
    drawShapes(t + f / numFrames);
  }

  drawText(t);

  // color[] textcolors = yellowwhite;
  // for (int f = 0; f < textcolors.length; f++) {
  //   float ff = textcolors.length - f - 1;
  //   text(t - ff / numFrames, textcolors[f]);
  // }
}
