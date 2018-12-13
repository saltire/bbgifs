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

color[] colors = new color[] {
  #000000,
  #1D2B53,
  #7E2553,
  #008751,
  #AB5236,
  #5F574F,
  #C2C3C7,
  #FFF1E8,
  #FF004D,
  #FFA300,
  #FFEC27,
  #00E436,
  #29ADFF,
  #83769C,
  #FF77A8,
  #FFCCAA,
};

color getColor(float colorValue) {
  return lerpColor(colors[floor(colorValue)], colors[ceil(colorValue)], colorValue % 1);
}

void setup() {
  size(640, 640);
  smooth(8);
  frameRate(30);

  result = new int[width * height][3];
}

float n = 30;
float tt = 0;

void draw_() {
  background(0);
  // translate(256, 256);
  scale(5);

  tt += .01;
  for (int i = 1; i <= n; i++) {
    for (int j = 1; j <= n; j++) {
      float x = i - n / 2;
      float y = j - n / 2;
      float z = cos((sqrt(64 - (x * x + y * y) * cos(tt * TAU)) / n - tt) * TAU) * 2;

      stroke(getColor(11.5 + z));

      line(
        i * 4 + cos(z * TAU) * z,
        j * 4 + sin(z * TAU) * z + z * 8,
        i * 4 + cos((.5 + z) * TAU) * z,
        j * 4 + sin((.5 + z) * TAU) * z + z * 8
      );
    }
  }
}
