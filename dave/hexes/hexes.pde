// by dave @beesandbombs

int[][] result;
float t, c;

float ease(float p) {
  return 3*p*p - 2*p*p*p;
}

float ease(float p, float g) {
  if (p < 0.5)
    return 0.5 * pow(2*p, g);
  else
    return 1 - 0.5 * pow(2*(1 - p), g);
}

float mn = .5*sqrt(3), ia = atan(sqrt(.5));

float c01(float g) {
  return constrain(g, 0, 1);
}

void draw() {
  if (recording) {
    for (int i=0; i<width*height; i++)
      for (int a=0; a<3; a++)
        result[i][a] = 0;

    c = 0;
    for (int sa=0; sa<samplesPerFrame; sa++) {
      t = map(frameCount-1 + sa*shutterAngle/samplesPerFrame, 0, numFrames, 0, 1);
      t %= 1;
      draw_();
      loadPixels();
      for (int i=0; i<pixels.length; i++) {
        result[i][0] += pixels[i] >> 16 & 0xff;
        result[i][1] += pixels[i] >> 8 & 0xff;
        result[i][2] += pixels[i] & 0xff;
      }
    }

    loadPixels();
    for (int i=0; i<pixels.length; i++)
      pixels[i] = 0xff << 24 |
        int(result[i][0]*1.0/samplesPerFrame) << 16 |
        int(result[i][1]*1.0/samplesPerFrame) << 8 |
        int(result[i][2]*1.0/samplesPerFrame);
    updatePixels();

    saveFrame("f###.gif");
    if (frameCount==numFrames)
      exit();
  } else if (preview) {
    c = mouseY*1.0/height;
    if (mousePressed)
      println(c);
    t = (millis()/(20.0*numFrames))%1;
    draw_();
  } else {
    t = mouseX*1.0/width;
    c = mouseY*1.0/height;
    if (mousePressed)
      println(c);
    draw_();
  }
}

//////////////////////////////////////////////////////////////////////////////

int samplesPerFrame = 4;
int numFrames = 150;
float shutterAngle = 1;

boolean recording = false,
  preview = true;

void setup() {
  size(750, 750, P3D);
  smooth(8);
  rectMode(CENTER);
  pixelDensity(recording ? 1 : 2);
  result = new int[width*height][3];
  fill(32);
  blendMode(EXCLUSION);
  noStroke();
}

color[] cs = { #ff0000, #00ff00, #0000ff};

float x, y, z, tt;
int N = 16;
float r = 16, sp = 2*r;

void hexx() {
  beginShape();
  for (int i=0; i<6; i++)
    vertex(r*cos(TWO_PI*i/6), r*sin(TWO_PI*i/6));
  endShape();
}

float shift, dd, rot;

void draw_() {
  background(250);
  push();
  translate(width/2, height/2);
  for (int a=0; a<3; a++) {
    fill(cs[a]);
    for (int i=-N; i<N; i++) {
      for (int j=-N; j<N; j++) {
        x = i*sp;
        y = (j-2/3.0)*mn*sp;
        if (j%2 != 0)
          x += .5*sp;

        dd = dist(x, y, 0, 0)/100.0;
        tt = (t + 120 -0.25*dd + atan2(x, y)/TWO_PI - 0.015*a)%1;

        shift = lerp(1, 0.9, ease(map(cos(TWO_PI*tt), 1, -1, 0, 1), 4));

        rot = TWO_PI*ease(c01(2*tt), 4)/12 + TWO_PI*ease(c01(2*tt-1), 4)/12;

        push();
        translate(x*shift, y*shift);
        rotate(rot);
        hexx();
        pop();
      }
    }
  }
  pop();
}
