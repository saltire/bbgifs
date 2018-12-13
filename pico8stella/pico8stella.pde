// True to save image files.
boolean recording = false;
// If not recording, true to control animation with mouse; false to play on loop.
// boolean mouseControl = false;

// Target frame count, and thus speed, for the recorded animation.
int numFrames = 360;
// Number of samples to take per frame when recording.
// Each frame will be an average of these. A higher value gives more of a motion blur effect.
int samplesPerFrame = 2;
// Time period, in frames, over which to spread out the samples.
float shutterAngle = 1;

void setup() {
  size(720, 720);
  smooth(8);
  frameRate(30);
  strokeWeight(2);

  result = new int[width * height][3];
}

float a = 1;
int h = 360;

void draw_() {
  background(0);

  float m = sin(a * .1 * TAU);
  a += .01;
  for (int i = 0; i <= 50; i++) {
    float j = i * .02;
    stroke(lerpColor(#FFF1E8, #FF004D, j));
    line(
      h + cos((j - m + a) * TAU) * sin(i * .1 * TAU) * h,
      h + sin((j + a) * TAU)     * cos(i * .1 * TAU) * h,
      h + sin((a - m + a) * TAU) * cos(i * .1 * TAU) * h,
      h + cos((a + m) * TAU)     * sin(i * .1 * TAU) * h
    );
  }
}
