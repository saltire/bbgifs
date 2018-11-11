float baseR = 2; // Radius of torus to center of cross-section.
float baser = 1; // Radius of cross-section.

float noiseScale = .5;
float offsetRadius = .3; // Should be somewhat proportional to number of animation frames.

float[] getOffsets(float t) {
  // Offset the torus in a circular motion along all three axes, to animate the noise in a loop.
  float[] offsets = new float[3];
  offsets[0] = (sin(t * TAU) + 1) * offsetRadius;
  offsets[1] = (cos(t * TAU) + 1) * offsetRadius;
  offsets[2] = (sin((t + .125) * TAU) + 1) * offsetRadius;
  return offsets;
}

float tilingNoise(float u, float v) {
  return tilingNoise(u, v, 0, 0, 0, noiseScale);
}

float tilingNoise(float u, float v, float scale) {
  return tilingNoise(u, v, 0, 0, 0, scale);
}

float tilingNoise(float u, float v, float[] offsets) {
  return tilingNoise(u, v, offsets[0], offsets[1], offsets[2], noiseScale);
}

float tilingNoise(float u, float v, float[] offsets, float scale) {
  return tilingNoise(u, v, offsets[0], offsets[1], offsets[2], scale);
}

float tilingNoise(float u, float v, float ox, float oy, float oz) {
  return tilingNoise(u, v, ox, oy, oz, noiseScale);
}

float tilingNoise(float u, float v, float ox, float oy, float oz, float scale) {
  float R = baseR * scale;
  float r = baser * scale;

  // Calculate the 3d coordinates of u,v (from 0 to 1) on the surface of a torus.
  // Offset the torus so its corner touches origin instead of its center.
  // This is because the noise() function seems to be mirrored along all its axes.
  float x = sin(u * TAU) * (R + sin(v * TAU) * r) + R;
  float y = cos(u * TAU) * (R + sin(v * TAU) * r) + R;
  float z = cos(v * TAU) * r + r;
  return noise(x + ox, y + oy, z + oz);
}
