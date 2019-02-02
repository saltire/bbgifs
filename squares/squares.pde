// True to save image files.
boolean recording = false;
// If not recording, true to control animation with mouse; false to play on loop.
boolean mouseControl = false;

// Target frame count, and thus speed, for the recorded animation.
int numFrames = 150;
// Number of samples to take per frame when recording.
// Each frame will be an average of these. A higher value gives more of a motion blur effect.
int samplesPerFrame = 1;
// Time period, in frames, over which to spread out the samples.
float shutterAngle = .3;


int numSquares = 21;
float maxSize = .9;
float grey = 255;

void setup() {
  size(750, 750);
  pixelDensity(recording ? 1 : 2);
  smooth(8);
  noStroke();

  rectMode(CENTER);

  result = new int[width * height][3];
}

void draw_() {
  background(255);

  float spacing = (float)width / numSquares;

  float minSize = 1 - maxSize;

  for (int x = 0; x < numSquares; x++) {
    for (int y = 0; y < numSquares; y++) {
      float center = (float)numSquares / 2 - .5;
      float amount = (center - max(abs(center - x), abs(center - y))) / center;

      float scale = (sin(t * TAU) / 2) * amount;
      float size = max(0, ((scale + .5) * (maxSize - minSize) + minSize) * spacing);

      push();
        fill((1 - (scale + .5)) * grey);
        translate(spacing * (x + .5), spacing * (y + .5));
        rotate(scale * TAU / 8);
        rect(0, 0, size, size);
      pop();
    }
  }
}
