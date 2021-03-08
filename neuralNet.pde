byte [] trainSet, lableSet;
neuralNetwork nn;
int l = 0;
int maxL = 5;
int maxN = 30;
int itL = 6;
int index = 0;


float [][] data = new float[maxL * itL][maxN];

void setup() {
	background(0);
	size(1200, 1200);
	//beginRecord(PDF, "data1.pdf");
	//colorMode(HSB);
	trainSet = loadBytes("train-images.idx3-ubyte");
	lableSet = loadBytes("train-labels.idx1-ubyte");
	//nn = new neuralNetwork(new int[]{784, 500, 300, 10});
	nn = new neuralNetwork("mnistRecognition");
}

void draw() {
  stroke(255);
  strokeWeight(100);
  if (mousePressed) line(pmouseX, pmouseY, mouseX, mouseY);
  float [] arr = createInput();
  nn.forwardProp(arr);
  println(nn.evaluate());
	//float sum = 0;
	//for (int i = 0; i < 100; i++) {
	//	float [] input = getMNISTInput(index);
	//	float [] lable = getMNISTAnswerArr(index);
	//	int answer = getMNISTAnswer(index);
	//	nn.backProp(input, lable);
	//	if (nn.evaluate() == answer)sum++;
	//	index++;
	//}
	//println(sum);
	//l++;
	//for (int j = 0; j < itL; j++) {
	//	for (int n = 1; n <= maxN; n++) {
	//		int index = 0;
	//		float [] input;
	//		float [] lable;
	//		int [] layers = new int[l + 2];
	//		layers[0] = 784;
	//		layers[l + 1] = 10;
	//		for (int i = 1; i < l + 1; i++)layers[i] = n * 25;
	//		nn = new neuralNetwork(layers);
	//		//train
	//		println("training...");
	//		for (int i = 0; i < 500; i++) {
	//			input = getMNISTInput(index);
	//			lable = getMNISTAnswerArr(index);
	//			nn.backProp(input, lable);
	//			index++;
	//		}
	//		//test
	//		println("testing...");
	//		float sum = 0;
	//		for (int i = 0; i < 500; i++) {
	//			input = getMNISTInput(index);
	//			lable = getMNISTAnswerArr(index);
	//			nn.backProp(input, lable);
	//			if (nn.evaluate() == getMNISTAnswer(index))sum++;
	//			index++;
	//		}
	//		println(l, n, j, sum / 5);
	//		data[l * itL - 1 - j][n - 1] = sum / 5;
	//	}
	//}
	//showData(data);
	//if (l == maxL) {
	//	endRecord();
	//	exit();
	//}
}

void keyPressed() {
  if (key == 'C' || key == 'c') background(0);
}

float[] createInput() {
  int dw = floor(width / 28);
  int dh = floor(height / 28);
  float[] arr = new float[28 * 28];
  for (int i = 0; i < 28; i++) {
    for (int j = 0; j < 28; j++) {
      color c = averageCol(i * dw, j * dh, dw, dh);
      arr[i + j * 28] = map(brightness(c), 0, 255, 0, 1);
    }
  }
  return arr;
}

void showInput(float [] arr) {
  int dw = floor(width / 28);
  int dh = floor(height / 28);
  for (int i = 0; i < 28; i++) {
    for (int j = 0; j < 28; j++) {
      fill(arr[j + i * 28] * 255);
      rect(i * dw, j * dh, dw, dh);
    }
  }
}

color averageCol(int x, int y, int w, int h) {
  PVector col = new PVector(0, 0, 0);
  for (int i = x; i <= x + w; i++) {
    for (int j = y; j <= y + h; j++) {
      col.x += red(get(x, y));
      col.y += green(get(x, y));
      col.z += blue(get(x, y));
    }
  }
  col.div(w * h);
  return color(col.x, col.y, col.z);
}


void showData(float [][] data) {
	float dw = width / maxL / itL;
	float dh = height / maxN;
	for (int i = 0; i < maxL * itL; i++)
		for (int j = 0; j < maxN; j++) {
			noStroke();
			float val = map(data[i][j], 0, 100, 0, 255);
			fill(val, 200, 200);
			rect(i * dw, j * dh, dw, dh);
		}
}
