void settings() {
  size(800, 800);
}

color[] purples = new color[] {
  color(235, 80, 200),
  color(145, 85, 215),
  color(190, 50, 180),
  color(0, 0, 0),
};
color green = color(90, 200, 110);

// float sqSize = 20;
int tiles = 10;

void draw_() {
  background(green);
  // noStroke();
  strokeWeight(1);

  float coverSize = sqrt(width * width + height * height);

  // int tiles = ceil(coverSize / sqSize / 4);
  // push();
  //   translate(width / 2, height / 2);
  //   rotate(TAU * t);
  //   translate(-coverSize / 2, -coverSize / 2);

  //   scale(sqSize);
  //   for (int x = -1; x < tiles; x++) {
  //     for (int y = -1; y < tiles; y++) {
  //       push();
  //         translate(x * 4, y * 4);
  //         for (int i = 0; i < 4; i++) {
  //           push();
  //             translate(i % 2 * 2, floor(i / 2) * 2);
  //             fill(purples[i]);
  //                 beginShape();
  //                   vertex(1, 0);
  //                   vertex(2, 1);
  //                   vertex(3, 1);
  //                   vertex(2, 2);
  //                   vertex(2, 3);
  //                   vertex(1, 2);
  //                   vertex(0, 2);
  //                   vertex(1, 1);
  //                 endShape(CLOSE);
  //           pop();
  //         }
  //       pop();
  //     }
  //   }
  // pop();

  float tileSize = coverSize / tiles;
  float sqRadius = sqrt(tileSize * tileSize * 2) / 8;

  push();
    translate(width / 2, height / 2);
    rotate(TAU / 8);
    translate(-coverSize / 2, -coverSize / 2);

    for (int x = -1; x < tiles; x++) {
      for (int y = -1; y < tiles; y++) {
        push();
          translate(x * tileSize, y * tileSize);
          rotate(TAU / 8);
          scale(sqRadius);
          strokeWeight(.5 / sqRadius);
          translate(5, 0);

          for (int st = 0; st < 4; st++) {
            push();
              rotate(TAU * st / 4);
              translate(-2, 0);
              fill(purples[st]);
              stroke(purples[st]);

              beginShape();
                for (int sq = 0; sq < 4; sq++) {
                  float sqDir = TAU * sq / 4;
                  float p1dir = sqDir + TAU / 8 * (5 + sin(t * TAU));
                  float p2dir = sqDir + TAU / 8 * (3 + sin(t * TAU));
                  vertex(sin(sqDir) * 2 + sin(p1dir), cos(sqDir) * 2 + cos(p1dir));
                  vertex(sin(sqDir) * 2 + sin(p2dir), cos(sqDir) * 2 + cos(p2dir));
                }
              endShape(CLOSE);
            pop();
          }
        pop();
      }
    }
  pop();
}
