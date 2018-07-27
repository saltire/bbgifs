// True to save image files.
boolean recording = false;
// If not recording, true to control animation with mouse; false to play on loop.
boolean mouseControl = false;

// Target frame count, and thus speed, for the recorded animation.
int numFrames = 360;
// Number of samples to take per frame when recording.
// Each frame will be an average of these. A higher value gives more of a motion blur effect.
int samplesPerFrame = 8;
// Time period, in frames, over which to spread out the samples.
float shutterAngle = 1;

void setup() {
  size(720, 720, P3D); // specify P3D renderer
  pixelDensity(recording ? 1 : 2);
  smooth(8);
  rectMode(CENTER); // rect(centerX, centerY, width, height)
  noStroke();
  ortho(); // orthographic camera (default is perspective)

  result = new int[width * height][3];
}


color c1 = #282828, c2 = #006f3c, c3 = #e177a8;
float baseSize = 180;
float size, radius;
float easing = 4;

void cube() {
  // Draw sides (black and green).
  for (int i = 0; i < 4; i++) {
    push();
    fill(i % 2 == 0 ? c1 : c2);
    rotateY(TAU / 4 * i);
    translate(0, 0, size / 2);
    rect(0, 0, size, size);
    pop();
  }

  // Draw top and bottom (pink).
  for (int i = 1; i < 4; i += 2) {
    push();
    fill(c3);
    rotateX(TAU / 4 * i);
    translate(0, 0, size / 2);
    rect(0, 0, size, size);
    pop();
  }
}

void shard() {
  // An equilateral triangle with one side going straight up from center, pointing right,
  // with the inner quarter cut off to make a trapezoid.
  beginShape();
  vertex(0, -radius);
  vertex(0, -radius * 2);
  vertex(radius * 2 * triHeight, -radius);
  vertex(radius * triHeight, -radius / 2);
  endShape();
}

void draw_() {
  push(); // start translation for this sample
  translate(width / 2, height / 2); // base coordinates on center

  // size = baseSize * pow(2, -t); // length of the cube's edge in 3d space
  size = map(t, 0, 1, baseSize, baseSize / 2); // alternate mapping
  radius = size * .815; // approximate foreshortened length of the cube's edge in 2d space

  background(250);


  // CUBE

  push(); // start cube rotation

  // Starting rotation
  rotateX(-isoAngle); // downward for isometric projection
  rotateY(TAU / 8); // 45 degrees to the right

  float tc = c01(t * 1.1); // inflate t to make the rotation happen a little faster

  // Rotations specified in timeline order.
  // Each rotation is relative to all cumulative previous rotations.
  // rotateY(-TAU / 4 * ease(c01(4 * tc), easing)); // Q1 of timeline
  // rotateZ(TAU / 4  * ease(c01(4 * tc - 1), easing)); // Q2 of timeline
  // rotateY(TAU / 4  * ease(c01(4 * tc - 2), easing)); // Q3 of timeline
  // rotateX(-TAU / 4 * ease(c01(4 * tc - 3), easing)); // Q4 of timeline

  // More intuitive if specified in reverse order,
  // as each rotation can be expressed as if there were no previous rotations in the timeline.
  rotateX(-TAU / 4 * ease(c01(tc * 4 - 3), easing)); // rotate over Q4 of timeline
  rotateZ(-TAU / 4 * ease(c01(tc * 4 - 2), easing)); // rotate over Q3 of timeline
  rotateX(-TAU / 4 * ease(c01(tc * 4 - 1), easing)); // rotate over Q2 of timeline
  rotateY(-TAU / 4 * ease(c01(tc * 4), easing)); // rotate over Q1 of timeline

  // Alternate way to map to each quarter of the timeline.
  // rotateY(-TAU / 4 * ease(c01(map(tc,   0, .25, 0, 1)), easing)); // Q1 of timeline
  // rotateZ(TAU / 4  * ease(c01(map(tc, .25,  .5, 0, 1)), easing)); // Q2 of timeline
  // rotateY(TAU / 4  * ease(c01(map(tc,  .5, .75, 0, 1)), easing)); // Q3 of timeline
  // rotateX(-TAU / 4 * ease(c01(map(tc, .75,   1, 0, 1)), easing)); // Q4 of timeline

  cube();
  pop(); // end cube rotation


  // SHARDS

  // ts = c01(t * 1.25 - 0.25); // map t to move faster, and shift it so it ends at the same time
  float ts = c01(map(t, .2, 1, 0, 1)); // alternate mapping, with similar results

  for (int i = 0; i < 6; i++) {
    fill(c1);
    if (i > 1) fill(c2);
    if (i > 3) fill(c3);

    push(); // start shard rotation/translation

    rotate(TAU * (i + 1) / 6); // rotate each of the six equally around the center
    translate(0, -600 + 600 * easeOut(ts)); // start 600 pixels away and move to the center

    shard();
    pop(); // end shard rotation/translation
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
