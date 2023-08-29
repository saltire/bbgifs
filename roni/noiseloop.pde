// By Roni Kaufman
// https://ronikaufman.github.io
// https://twitter.com/KaufmanRoni

let margin = 4;
let N = 32;
let u;
let palette = ["#abcd5e", "#14976b", "#2b67af", "#62b6de", "#f589a3", "#ef562f", "#fc8405", "#f9d531"];
let N_FRAMES = 500;
let rad = 1, sc = 1/1000, offset = 10, theta; // parameters for the noise

let squares = [];

let randInt = (a, b) => (floor(random(a, b)));

function setup() {
  createCanvas(600, 600);
	frameRate(30);
	u = width / N;
	gap = u / 4;

  stroke("#2c2060");
  strokeWeight(1);

	createComposition();
}

function draw() {
	background("#fffbe6");

	theta = TWO_PI*(frameCount%N_FRAMES)/N_FRAMES;
  for (let squ of squares) {
		drawSquare(squ.i*u+gap/2, squ.j*u+gap/2, squ.s*u-gap);
	}
}

function createComposition() {
	for (let i = 0; i < 1000; i++) {
    let newSqu = generateSquare();
    let canAdd = true;
    for (let squ of squares) {
      if (squaresIntersect(newSqu, squ)) {
        canAdd = false;
        break;
      }
    }
    if (canAdd) {
      squares.push(newSqu);
    }
  }

  // fill the gaps with 1x1 squares
	for (let i = margin; i < N-margin; i++) {
		for (let j = margin; j < N-margin; j++) {
			let newSqu = {
				i: i,
				j: j,
				s: 1
			}
			let canAdd = true;
			for (let squ of squares) {
				if (squaresIntersect(newSqu, squ)) {
					canAdd = false;
					break;
				}
			}
			if (canAdd) {
				squares.push(newSqu);
			}
		}
	}
}

function squaresIntersect(squ1, squ2) {
	return ((squ1.i <= squ2.i && squ1.i+squ1.s > squ2.i) || (squ2.i <= squ1.i && squ2.i+squ2.s > squ1.i)) && ((squ1.j <= squ2.j && squ1.j+squ1.s > squ2.j) || (squ2.j <= squ1.j && squ2.j+squ2.s > squ1.j))
}

function generateSquare() {
  let s = random([2]);
  let i = randInt(margin, N-margin-s+1);
  let j = randInt(margin, N-margin-s+1);
  let squ = {
    i: i,
    j: j,
    s: s
  };
  return squ;
}

function drawSquare(x, y, s) {
	let noice = noise(
		offset + rad*cos(x*sc+theta),
		offset + rad*sin(x*sc+theta),
		y*sc
	);
	fill(palette[floor(6*noice*palette.length)%palette.length]);
	square(x, y, s);
}
