float baseR = 2; // radius of torus to center of cross-section
float baser = 1; // radius of cross-section

// x and y should be between 0 and 1.
float tilingNoise(float x, float y, float scale) {
  float R = baseR * scale;
  float r = baser * scale;

  // Calculate the 3d coordinates of x,y on the surface of a torus.
  // Offset the torus so its corner touches origin instead of its center.
  // This is because the noise() function seems to be mirrored along all its axes.
  float xx = sin(x * TAU) * (R + sin(y * TAU) * r) + R;
  float yy = cos(x * TAU) * (R + sin(y * TAU) * r) + R;
  float zz = cos(y * TAU) * r + r;
  return noise(xx, yy, zz);
}

float tilingNoise(float x, float y) {
  return tilingNoise(x, y, 1);
}
