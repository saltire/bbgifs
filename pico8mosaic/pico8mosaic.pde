// True to save image files.
boolean recording = false;
// If not recording, true to control animation with mouse; false to play on loop.
boolean mouseControl = false;

// Target frame count, and thus speed, for the recorded animation.
int numFrames = 360;
// Number of samples to take per frame when recording.
// Each frame will be an average of these. A higher value gives more of a motion blur effect.
int samplesPerFrame = 2;
// Time period, in frames, over which to spread out the samples.
float shutterAngle = 1;

color[] colors = new color[] {
  #7E2553,
  #AB5236,
  #FFA300,
  #FFEC27,
  #FFF1E8,
};

color getColor(float colorValue) {
  return lerpColor(
    colors[constrain(floor(colorValue), 0, colors.length - 1)], 
    colors[constrain(ceil(colorValue), 0, colors.length - 1)], 
    colorValue % 1);
}

float size = 6;
float variance = 2;
float xstep = (size + variance) * 2.75;
float ystep = (size + variance) * 1.75;

float radius = 6;
float maxArms = 10;
float armsSpeed = .5;
float curveSize = 15;
float pulseSize = 150;
float pulseSpeed = 1;

int cols;
int rows;
int xmid;
int ymid;

void setup() {
  size(640, 640);
  smooth(8);
  frameRate(30);
  background(0);
  strokeJoin(ROUND);
  strokeWeight(variance * 2);

  cols = ceil(width / xstep) + 1;
  rows = ceil(height / ystep) + 1;
  xmid = floor(cols / 2);
  ymid = floor(rows / 2);

  result = new int[width * height][3];
}

void draw_() {
  float cx = xmid + (sin(t * TAU) * radius);
  float cy = ymid + (sin((t + .25) * TAU) * radius);

  for (int y = 0; y < rows; y++) {
    float xoffset = 0;
    if (y % 2 == 1) xoffset += xstep / 2;
    float yoffset = 0;

    for (int x = 0; x < cols; x++) {
      push();
        float dx = cx - x;
        float dy = cy - y;
        float angle = atan2(dx, dy) / TAU + .5;
        float dist = sqrt((dx * dx) + (dy * dy));
        
        float colorValue = 
          ((
            sin((
              (angle * sin(t * armsSpeed * TAU) * maxArms)
              + (dist / curveSize)
              + t
            ) * TAU)
            + sin((
              (dx * dy) / pulseSize
              + (t * pulseSpeed)
            ) * TAU)
          ) * 5.5 / 5) + 1.5;

        color colour = getColor(colorValue % 4);
        fill(colour);
        stroke(colour);

        translate(x * xstep + xoffset, y * ystep + yoffset);

        int ox = round(random(1)) * 2 - 1;
        int oy = round(random(1)) * 2 - 1;
        translate(ox * variance / 2, oy * variance / 2);

        beginShape();
          vertex(-size, 0);
          vertex(0, -size);
          vertex(size, 0);
          vertex(0, size);
        endShape(CLOSE);
      pop();

    }
  }
}
