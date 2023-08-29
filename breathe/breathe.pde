void settings() {
  size(1080, 1920, P2D);
}

float dw = 150;
float dh = dw / 2;
float gap = 50;
float rh = 100;

float yvar = 400;

float textYvar = 300;

int wings;
float center;
float ycenter;
PFont font;

color[] synthwave = new color[] {
  #f72585, #b5179e, #7209b7, #560bad, #480ca8, #3a0ca3, #3f37c9, #4361ee, #4895ef, #4cc9f0
};
color[] fire = new color[] {
  #03071e, #370617, #6a040f, #9d0208, #d00000, #dc2f02, #e85d04, #f48c06, #faa307, #ffba08
};

color getColor(color[] colors, float value) {
  float colorValue = value * (colors.length - 1);
  return lerpColor(colors[floor(colorValue)], colors[ceil(colorValue)], colorValue % 1);
}

void diamond(float x, float y) {
  beginShape();
  vertex(x, y);
  vertex(x + dw / 2, y + dh / 2);
  vertex(x, y + dh);
  vertex(x - dw / 2, y + dh / 2);
  endShape();
}

color red = color(255, 0, 0);
color blue = color(0, 0, 255);

void diamonds(float t) {
  float c = sin((t + 0.75) * TAU);
  float c01 = norm(c, -1, 1);

  push();
    fill(getColor(fire, c01));

    float y = (-c - 1) * yvar;
    int r = 0;
    while (y < height) {
      if ((r % 2) == 0) {
        diamond(center, y);
        for (int i = 1; i <= wings; i++) {
          diamond(center - (dw + gap) * i, y);
          diamond(center + (dw + gap) * i, y);
        }
      }
      else {
        for (int i = 1; i <= wings; i++) {
          diamond(center - (dw + gap) * (i - 0.5), y);
          diamond(center + (dw + gap) * (i - 0.5), y);
        }
      }

      y += rh;
      r += 1;
    }
  pop();
}

void text(float t) {
  float c = sin((t + 0.75) * TAU);

  push();
    fill(t < 0.5 ? 255 : 0, ease(1 - abs(c), 3) * 255);
    text(t < 0.5 ? "BREATHE IN" : "BREATHE OUT", center, ycenter - c * textYvar);
  pop();
}

void setup_() {
  noStroke();

  wings = ceil((width / 2) / (dw + gap));
  center = width / 2 + 0.5;
  ycenter = height / 2 + 0.5;

  font = createFont("PramukhRounded-Semibold", 360);
  textFont(font);
  textAlign(CENTER, CENTER);
}

void draw_() {
  background(0);

  for (float f = 1; f <= numFrames; f++) {
    diamonds(t + f / numFrames);
  }

  text(t);
}
