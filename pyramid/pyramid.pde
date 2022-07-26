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
  stroke(0);
  noFill();
  ortho();

  result = new int[width * height][3];
}

float size = 200;
float thickness = 10;
color[] colors = { #e57272, #e5a667, #e5e567, #a2d86c, #6cd8d8, #72ace5, #ac72e5, #d86ca2 };

void draw_() {
  background(0);
  push();
  translate(width / 2, height / 2);
  rotateX(TAU / 4 - isoAngle); // upward for isometric projection with Z pointing up
  rotateZ(TAU / 8); // 45 degrees clockwise

  float colorPhase = t * colors.length;

  beginShape();
    int layers = colors.length;
    float pHeight = triHeight * size * 2;

    for (int i = 0; i <= layers; i++) {
      push();
        float bottomSize = max(0, min(size, size * (layers - i - 0.5 + t) / float(layers)));
        float topSize = max(0, min(size, size * (layers - i - 1 + t) / float(layers)));

        float bottomHeight = max(0, pHeight * (i + 0.5 - t) / float(layers));
        float topHeight = min(pHeight, pHeight * (i + 1 - t) / float(layers));

        float layerColorPhase = i - colorPhase + colors.length;
        fill(lerpColor(
          colors[ceil(layerColorPhase) % colors.length],
          colors[floor(layerColorPhase) % colors.length],
          colorPhase % 1));

        beginShape();
          vertex(-bottomSize, bottomSize, bottomHeight);
          vertex(bottomSize, -bottomSize, bottomHeight);
          vertex(topSize, -topSize, topHeight);
          vertex(-topSize, topSize, topHeight);
        endShape(CLOSE);

        beginShape();
          vertex(-bottomSize, bottomSize, bottomHeight);
          vertex(bottomSize, bottomSize, bottomHeight);
          vertex(topSize, topSize, topHeight);
          vertex(-topSize, topSize, topHeight);
        endShape(CLOSE);

        beginShape();
          vertex(bottomSize, bottomSize, bottomHeight);
          vertex(bottomSize, -bottomSize, bottomHeight);
          vertex(topSize, -topSize, topHeight);
          vertex(topSize, topSize, topHeight);
        endShape(CLOSE);

        beginShape();
          vertex(-topSize, topSize, topHeight);
          vertex(topSize, topSize, topHeight);
          vertex(topSize, -topSize, topHeight);
          beginContour();
            vertex(max(0, topSize - thickness), min(0, -topSize + thickness * 2.5), topHeight);
            vertex(max(0, topSize - thickness), max(0, topSize - thickness), topHeight);
            vertex(min(0, -topSize + thickness * 2.5), max(0, topSize - thickness), topHeight);
          endContour();
        endShape(CLOSE);
      pop();
    }

  endShape();

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
