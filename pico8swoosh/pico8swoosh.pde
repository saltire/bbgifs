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
  // #FFCCAA,
  #1D2B53, // map peach to blue
};

float dotspacing = 22.5;
float dotradius = 8;
float xspd = .5;
float yspd = .3;
float sizespd = .25;
float circsize = 5;
float rndsmooth = 2;
int framerate = 30;

int rows;
int cols;
int[][] dotcolors;

void setup() {
  size(720, 720);
  smooth(8);
  noStroke();
  ellipseMode(RADIUS);
  frameRate(framerate);

  result = new int[width * height][3];

  rows = ceil(height / dotspacing / triHeight);
  cols = ceil(width / dotspacing) + 1;
  dotcolors = new int[cols][rows];
}

void draw_() {
  background(0);

  float t = (float)frameCount / framerate;

  float circx = (cos(t * xspd * TAU) + 1) * width / 2;
  float circy = (sin(t * yspd * TAU) + 1) * height / 2;
  float circradius = circsize * 10 / (cos(t * sizespd * TAU) + 1.25);

  for (int row = 0; row < rows; row++) {
    for (int col = 0; col < cols; col++) {
      float px = (col + .5 - (((float)row % 2) / 2)) * dotspacing;
      float py = (row + .5) * dotspacing * triHeight;

      int dotcolor = dotcolors[col][row];

      float dx = circx - px;
      float dy = circy - py;
      if ((dx * dx) + (dy * dy) < (circradius * circradius)) {
        dotcolor = 7;
      }
      else {
        // int rndy = round(randomGaussian() / rndsmooth);
        // float rndxf = randomGaussian() / rndsmooth;
        // if (rndy % 2 == 1) {
        //   rndxf += row % 2 == 1 ? .5 : -.5;
        // }
        // int rndx = round(rndxf);

        // int newcol = constrain(col + rndx, 0, cols - 1);
        // int newrow = constrain(row + rndy, 0, rows - 1);
        // int newcolor = dotcolors[newcol][newrow];

        int ncol = constrain(col + (row % 2 == 1 ? -1 : 1), 0, cols - 1);
        int prow = constrain(row - 1, 0, rows - 1);
        int nrow = constrain(row + 1, 0, rows - 1);
        int[] newcolors = new int[] {
          dotcolors[col][prow],
          dotcolors[col][nrow],
          dotcolors[ncol][prow],
          dotcolors[ncol][nrow],
          dotcolors[col][row],
          dotcolors[col][row],
          dotcolors[col][row],
          dotcolors[col][row],
          dotcolors[col][row],
          0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        };
        int newcolor = newcolors[int(random(0, 25))];

        if (newcolor > 0) {
          dotcolor = (newcolor + 1) % colors.length;
        }
      }

      dotcolors[col][row] = dotcolor;
      fill(colors[dotcolors[col][row]]);
      ellipse(px, py, dotradius, dotradius);
    }
  }
}
