// True to save image files.
boolean recording = false;
// If not recording, true to control animation with mouse; false to play on loop.
boolean mouseControl = false;

// Target frame count, and thus speed, for the recorded animation.
int numFrames = 240;
// Number of samples to take per frame when recording.
// Each frame will be an average of these. A higher value gives more of a motion blur effect.
int samplesPerFrame = 4;
// Time period, in frames, over which to spread out the samples.
float shutterAngle = .6;

void setup() {
  size(750, 750, P3D);
  pixelDensity(recording ? 1 : 2);
  smooth(8);
  rectMode(CENTER);
  stroke(255);
  strokeWeight(1.7);
  noFill();

  result = new int[width * height][3];
}


int vertexCount = 720;
int loopCount = 12;
float maxLoopRadius = 42;
int armCount = 12;
float armLength = 300;
float waveAmp = TAU / 20;
float waveLength = 2;

void spiral(float armPhase) {
  beginShape();
  for (int i = 0; i < vertexCount; i++) {
    float pos = i / float(vertexCount - 1);
    float loopRadius = map(cos(TAU * pos), 1, -1, 0, maxLoopRadius) * sqrt(pos);
    float loopPhase = (loopCount * TAU * pos) - (4 * TAU * t) - armPhase;
    float x = loopRadius * cos(loopPhase);
    float y = (-armLength * pos) + (loopRadius * sin(loopPhase));

    float wavePhase = waveAmp * sin(TAU * (t - (pos / waveLength)));
    float xx = (x * cos(wavePhase)) + (y * sin(wavePhase));
    float yy = (y * cos(wavePhase)) - (x * sin(wavePhase));

    vertex(xx, yy);
  }
  endShape();
}

void draw_() {
  background(0);
  push();
  translate(width / 2, height / 2);
  for (int i = 0; i < armCount; i++) {
    float armPhase = TAU * i / armCount;
    push();
    rotate(armPhase);
    spiral(armPhase);
    pop();
  }
  pop();
}


////////////////////////////////////////////////////////////////////////////////


int[][] result;
float t, c;

// height of an equilateral triangle with side length 1: 0.8660254
float triHeight = sqrt(3) / 2;
// rotation angle on x-axis for isometric projection: 35.26439 deg
float isoAngle = atan(1 / sqrt(2));

float easeOut(float value) {
  return 1 - sq(1 - value);
}

float ease(float value) {
  return 3 * pow(value, 2) - 2 * pow(value, 3);
}

float ease(float value, float exp) {
  return value < 0.5 ?
    pow(value * 2, exp) / 2 :
    1 - pow((1 - value) * 2, exp) / 2;
}

void push() {
  pushMatrix();
  pushStyle();
}

void pop() {
  popStyle();
  popMatrix();
}

// Clamp/constrain a value between 0 and 1.
float c01(float value) {
  return constrain(value, 0, 1);
}

void draw() {
  // Control the animation with the mouse position on the X-axis.
  if (!recording) {
    if (mouseControl) {
      t = mouseX * 1.0 / width;
      c = mouseY * 1.0 / height;

      if (mousePressed) {
        println(c);
      }
    }
    else {
      t = map((frameCount - 1) % numFrames, 0, numFrames, 0, 1);
    }

    draw_();
  }
  else {
    // Initialize a pixel buffer.
    for (int i = 0; i < width * height; i++) {
      for (int a = 0; a < 3; a++) {
        result[i][a] = 0;
      }
    }

    c = 0;
    for (int sa = 0; sa < samplesPerFrame; sa++) {
      // For each sample, set the time somewhere between the frame and (frame + shutterAngle).
      t = map(frameCount - 1 + sa * shutterAngle / samplesPerFrame, 0, numFrames, 0, 1);
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
    saveFrame("f###.gif");
    if (frameCount == numFrames) {
      exit();
    }
  }
}
