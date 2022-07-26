int samplesPerFrame = 4;
int numFrames = 450;
float shutterAngle = .6;

boolean recording = false;
boolean mouseControl = false;

void setup() {
  size(800, 800, P3D);
  smooth(8);
  rectMode(CENTER);
  fill(32);
  noStroke();

  result = new int[width * height][3];
}

float tt;
int points = 12;
float qq, rot;
int nx = 20;


float r, th;
void vert(float th_, float r_) {
  r = 100 * pow(1.7, r_ + 3 * th_ / PI);
  th = th_;
  strokeWeight(0.5 + .012 * r);
  vertex(r * cos(th), r * sin(th));
}

void lin(float x1, float y1, float x2, float y2) {
  for (int i = 0; i < points; i++) {
    qq = i / float(points - 1);
    vert(lerp(x1, x2, qq), lerp(y1, y2, qq));
  }
}

void diamond(float th_, float r_) {
  beginShape();
  lin(th_,               r_ + .5, th_ + PI     / nx, r_ + 1 );
  lin(th_ + PI     / nx, r_ + 1,  th_ + TWO_PI / nx, r_ + .5);
  lin(th_ + TWO_PI / nx, r_ + .5, th_ + PI     / nx, r_     );
  lin(th_ + PI     / nx, r_,      th_,               r_ + .5);
  endShape(CLOSE);
}


color blu = #0054B9;
boolean flip;

void draw_() {
  flip = t >= .5; // first or second run
  float t2 = (2 * t) % 1; // double time to move animation twice as fast, in two runs

  background(flip ? 250 : blu);
  fill(flip ? blu : 250);

  push();
  translate(width / 2, height / 2);

  if (t2 <= .5) { // first half of each run: rotating animation
    tt = ease(2 * t2, 5);
    for (int a = -16; a < 6; a++) {
      for (int i = 0; i < nx; i++) {
        rot = TWO_PI * i / nx + PI * (a % 2 == 0 ? -tt : tt) / nx;
        diamond(rot, a);
      }
    }
  }
  else { // second half of each run: in/out animation
    tt = ease(2 * t2 - 1, 5);
    for (int a = -16; a < 6; a++) {
      for (int i = 0; i < nx; i++) {
        rot = TWO_PI * (i + .5) / nx;
        diamond(rot, a + (i % 2 == 0 ? .5 * tt : -.5 * tt));
      }
    }
  }

  pop();
}
