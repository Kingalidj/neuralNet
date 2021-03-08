class neuralNetwork {
	int numInputNodes, numOutputNodes;
	matrix[] layers, weights, biases;
	matrix error;
	float learningRate = 0.1;

	neuralNetwork(int[] layersArray) {
		numInputNodes = layersArray[0];
		numOutputNodes = layersArray[layersArray.length - 1];

		layers = new matrix[layersArray.length];
		weights = new matrix[layersArray.length - 1];
		biases = new matrix[layersArray.length - 1];

		for (int i = 0; i < layersArray.length - 1; i++) {
			weights[i] = new matrix(layersArray[i + 1], layersArray[i]);
			biases[i] = new matrix(layersArray[i + 1], 1);
			randomizeMatrix(weights[i]);
			randomizeMatrix(biases[i]);
		}
	}

	neuralNetwork(String fileName) {
		loadNeuralNetwork(fileName);
	}

	void saveNeuralNetwork(String fileName) {
		String[] save = new String[weights.length + biases.length + 3];
		save[0] = numInputNodes + " ";
		for (int i = 0; i < biases.length; i++) save[0] += biases[i].rows + " ";
		save[1] = "w:";
		save[weights.length + 2] = "b:";
		for (int i = 0; i < weights.length; i++) {
			save[i + 2] = matrixToString(weights[i]);
			save[i + weights.length + 3] = matrixToString(biases[i]);
		}
		saveStrings(fileName + ".txt", save);
		println("saved succesfully");
	}

	void loadNeuralNetwork(String fileName) {
		String[] load = loadStrings(fileName + ".txt");
		boolean loaded = false;
		try {
			if (load.length > 0) loaded = true;
		} catch (NullPointerException e) {
			loaded = false;
			println("loading failed");
		}

		if (loaded) {

			String[] layersStringArray = split(trim(load[0]), " ");
			int[] layersArray = new int[layersStringArray.length];
			for (int i = 0; i < layersArray.length; i++) layersArray[i] = Integer.parseInt(layersStringArray[i]);
			numInputNodes = layersArray[0];
			numOutputNodes = layersArray[layersArray.length - 1];

			layers = new matrix[layersArray.length];
			weights = new matrix[layersArray.length - 1];
			biases = new matrix[layersArray.length - 1];

			for (int i = 0; i < weights.length; i++) {

				String line = trim(load[i + 2]);
				String[] letters = split(line, " ");
				float[] numbers = new float[letters.length];
				for (int j = 0; j < numbers.length; j++) numbers[j] = Float.parseFloat(letters[j]);

				weights[i] = new matrix(layersArray[i + 1], layersArray[i], numbers);

				line = trim(load[i + weights.length + 3]);
				letters = split(line, " ");
				numbers = new float[letters.length];
				for (int j = 0; j < numbers.length; j++) numbers[j] = Float.parseFloat(letters[j]);

				biases[i] = new matrix(layersArray[i + 1], 1, numbers);
			}
			println("loaded succesfully");
		}
	}

	float[] forwardProp(float[] inputArray) {
		if (inputArray.length != numInputNodes) {
			println("ERROR! wrong inputlength");
			return null;
		}
		layers[0] = arrayToMatrix(inputArray);
		for (int i = 1; i < layers.length; i++) {
			layers[i] = multMatrix(weights[i - 1], layers[i - 1]);
			layers[i] = addMatrix(layers[i], biases[i - 1]);
			layers[i] = sigmoidMatrix(layers[i]);
		}
		return matrixToArray(layers[layers.length - 1]);
	}

	void backProp(float[] inputArray, float[] answerArray) {
		if (inputArray.length != numInputNodes) {
			println("ERROR! wrong inputlength");
		}
		if (answerArray.length != numOutputNodes) {
			println("ERROR! wrong answerlength");
		}

		matrix gradient, weightDelta;
		forwardProp(inputArray);

		matrix answer = arrayToMatrix(answerArray);
		error = subMatrix(answer, layers[layers.length - 1]);
		error = multElementMatrix(error, 2);

		for (int i = layers.length - 2; i >= 0; i--) {

			gradient = dSigmoidMatrix(layers[i + 1]);
			gradient = multElementMatrix(gradient, error);
			gradient = multElementMatrix(gradient, learningRate);

			weightDelta = multMatrix(gradient, transposeMatrix(layers[i]));

			weights[i] = addMatrix(weights[i], weightDelta);
			biases[i] = addMatrix(biases[i], gradient);
      //error = multElementMatrix(error, dSigmoidMatrix(layers[i + 1]));
      //what the fuck?
			error = multMatrix(transposeMatrix(weights[i]), error);
      //error = multMatrix(transposeMatrix(weights[i]), gradient);
		}
	}

	int evaluate() {
		int j = 0;
		float[] output = matrixToArray(layers[layers.length - 1]);
		for (int i = 0; i < output.length; i++) {
			if (output[i] > output[j]) j = i;
		}
		return j;
	}
}

void showMNISTInput(float [] grid) {
	int rectScale = width / 28;
	for (int i = 0; i < 28; i++)
		for (int j = 0; j < 28; j++) {
			int ind = i + j * 28;
			fill(grid[ind] * 255);
			noStroke();
			rect(i * rectScale, j * rectScale, rectScale, rectScale);
		}
}

float [] getMNISTInput(int index) {
	float [] input = new float[784];
	if (index >= 60000)index -= 60000;
	for (int i = 0; i < 784; i++) {
		float val = int(trainSet[i + 784 * index + 16]);
		val = map(val, 0, 255, 0, 1);
		input[i] = val;
	}
	return input;
}

float [] getMNISTAnswerArr(int index) {
	float [] answerArray = new float[10];
	if (index >= 60000)index -= 60000;
	int i = round(lableSet[index + 8]);
	answerArray[i] = 1;
	return answerArray;
}

int getMNISTAnswer(int index) {
	float [] answerArray = new float[10];
	if (index >= 60000)index -= 60000;
	return round(lableSet[index + 8]);
}
