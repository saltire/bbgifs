// True to save image files.
boolean recording = false;
// If not recording, true to control animation with mouse; false to play on loop.
boolean mouseControl = false;

// Target frame count, and thus speed, for the recorded animation.
int numFrames = 300;
// Number of samples to take per frame when recording.
// Each frame will be an average of these. A higher value gives more of a motion blur effect.
int samplesPerFrame = 4;
// Time period, in frames, over which to spread out the samples.
float shutterAngle = 2;

int[][] result;
float t;

void setup() {
  if (recording) {
    result = new int[width * height][3];
  }
}

void draw() {
  if (recording) {
    saveGif();
  }
  else {
    preview();
  }
}

void preview() {
  if (mouseControl) {
    // Control the animation with the mouse position on the X-axis.
    t = float(mouseX) / width;
  }
  else {
    t = norm((frameCount - 1) % numFrames, 0, numFrames);
  }

  draw_();
}

void saveGif() {
  // Initialize a pixel buffer.
  for (int i = 0; i < width * height; i++) {
    for (int a = 0; a < 3; a++) {
      result[i][a] = 0;
    }
  }

  for (int sa = 0; sa < samplesPerFrame; sa++) {
    // For each sample, set the time somewhere between the frame and (frame + shutterAngle).
    t = norm(frameCount - 1 + sa * shutterAngle / samplesPerFrame, 0, numFrames);
    draw_();

    // Add the value of this sample to the result.
    loadPixels();
    for (int i = 0; i < pixels.length; i++) {
      result[i][0] += pixels[i] >> 16 & 0xff;
      result[i][1] += pixels[i] >> 8 & 0xff;
      result[i][2] += pixels[i] & 0xff;
    }
  }

  // Divide the values by the number of samples to get the average.
  // loadPixels(); // not sure if this is necessary
  for (int i = 0; i < pixels.length; i++) {
    pixels[i] = 0xff << 24 |
      int(result[i][0] * 1.0 / samplesPerFrame) << 16 |
      int(result[i][1] * 1.0 / samplesPerFrame) << 8 |
      int(result[i][2] * 1.0 / samplesPerFrame);
  }
  updatePixels();

  // Save frame to disk and exit if finished.
  saveFrame("gif/f###.gif");
  println(frameCount + "/" + numFrames);
  if (frameCount == numFrames) {
    exit();
  }
}
