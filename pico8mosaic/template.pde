int[][] result;
float t, c;

// height of an equilateral triangle with side length 1: 0.8660254
float triHeight = sqrt(3) / 2;
// // rotation angle on x-axis for isometric projection: 35.26439 deg
// float isoAngle = atan(1 / sqrt(2));

// float easeOut(float value) {
//   return 1 - sq(1 - value);
// }

// float ease(float value) {
//   return 3 * pow(value, 2) - 2 * pow(value, 3);
// }

// float ease(float value, float exp) {
//   return value < 0.5 ?
//     pow(value * 2, exp) / 2 :
//     1 - pow((1 - value) * 2, exp) / 2;
// }

void push() {
  pushMatrix();
  pushStyle();
}

void pop() {
  popStyle();
  popMatrix();
}

// // Clamp/constrain a value between 0 and 1.
// float c01(float value) {
//   return constrain(value, 0, 1);
// }

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
      t = norm((frameCount - 1) % numFrames, 0, numFrames);
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
    saveFrame("f###.gif");
    if (frameCount == numFrames) {
      exit();
    }
  }
}
