class matrix {
  int rows, cols;
  float[][] m;

  matrix(int rows, int cols) {
    this.rows = rows;
    this.cols = cols;
    m = new float[rows][cols];
  }

  matrix(int rows, int cols, float[] numbers){
    this.rows = rows;
    this.cols = cols;
    m = new float[rows][cols];
    for (int i = 0; i < rows; i++){
      for (int j = 0; j < cols; j++){
        m[i][j] = numbers[j + i * cols];
      }
    }
  }

  matrix(matrix m1) {
    this.rows = m1.rows;
    this.cols = m1.cols;
    m = new float[this.rows][this.cols];
  }
  
  matrix copy() {
  	matrix m1 = new matrix(this);
	for (int i = 0; i < rows; i++)
		for (int j = 0; j < cols; j++)
			m1.m[i][j] = this.m[i][j];
	return m1;
  }

}

matrix multMatrix(matrix m1, matrix m2) {
  if (m1.cols == m2.rows) {
    matrix m3 = new matrix(m1.rows, m2.cols);
    for (int i = 0; i < m1.rows; i++) {
      for (int j = 0; j < m2.cols; j++) {
        float sum = 0;
        for (int k = 0; k < m1.cols; k++) {
          sum += m1.m[i][k] * m2.m[k][j];
        }
        m3.m[i][j] = sum;
      }
    }
    return m3;
  } else {
    println("multiplication not possible! number of cols or rows is incorrect.");
    return null;
  }
}

matrix multElementMatrix(matrix m1, float n) {
  matrix m2 = new matrix(m1);
  for (int i = 0; i < m1.rows; i++)
    for (int j = 0; j < m1.cols; j++)
      m2.m[i][j] = m1.m[i][j] * n;
  return m2;
}

matrix multElementMatrix(matrix m1, matrix m2) {
  if (m1.cols == m2.cols && m1.rows == m2.rows) {
    matrix m3 = new matrix(m1);
    for (int i = 0; i < m1.rows; i++)
      for (int j = 0; j < m1.cols; j++)
        m3.m[i][j] = m1.m[i][j] * m2.m[i][j];
    return m3;
  } else {
    println("Elementwise multiplication not possible: cols and rows dont match!");
    return null;
  }
}

matrix addMatrix(matrix m1, float n) {
  matrix m2 = new matrix(m1);
  for (int i = 0; i < m1.rows; i++)
    for (int j = 0; j < m1.cols; j++)
      m2.m[i][j] = m1.m[i][j] + n;
  return m2;
}

matrix addMatrix(matrix m1, matrix m2) {
  if (m1.rows == m2.rows && m1.cols == m2.cols) {
    matrix m3 = new matrix(m2);
    for (int i = 0; i < m1.rows; i++)
      for (int j = 0; j < m1.cols; j++)
        m3.m[i][j] = m1.m[i][j] + m2.m[i][j];
    return m3;
  } else {
    println("Addition not possible! Matrix rows or cols don't match.");
    return null;
  }
}

matrix subMatrix(matrix m1, matrix m2) {
  if (m1.rows == m2.rows && m1.cols == m2.cols) {
    matrix m3 = new matrix(m1);
    for (int i = 0; i < m1.rows; i++)
      for (int j = 0; j < m1.cols; j++)
        m3.m[i][j] = m1.m[i][j] - m2.m[i][j];
    return m3;
  } else {
    println("Subtraction not possible! Matrix rows or cols don't match.");
    return null;
  }
}

matrix transposeMatrix(matrix m1) {
  matrix result = new matrix(m1.cols, m1.rows);
  for (int i = 0; i < m1.rows; i++)
    for (int j = 0; j < m1.cols; j++)
      result.m[j][i] = m1.m[i][j];
  return result;
}

void printMatrix(matrix m1) {
  println();
  for (int i = 0; i < m1.rows; i++) {
    for (int j = 0; j < m1.cols; j++) {
      print(m1.m[i][j] + " ");
    }
    println();
  }
  println();
}

void randomizeMatrix(matrix m1) {
  for (int i = 0; i < m1.rows; i++)
    for (int j = 0; j < m1.cols; j++)
      m1.m[i][j] = random(-1, 1);
}

matrix sigmoidMatrix(matrix m1) {
  matrix m2 = new matrix(m1);
  for (int i = 0; i < m1.rows; i++)
    for (int j = 0; j < m1.cols; j++)
      m2.m[i][j] = sigmoid(m1.m[i][j]);
  return m2;
}

matrix dSigmoidMatrix(matrix m1) {
  matrix m2 = new matrix(m1);
  for (int i = 0; i < m1.rows; i++)
    for (int j = 0; j < m1.cols; j++)
      m2.m[i][j] = dSigmoid(m1.m[i][j]);
  return m2;
}

matrix arrayToMatrix(float[] array) {
  matrix m = new matrix(array.length, 1);
  for (int i = 0; i < array.length; i++)
    m.m[i][0] = array[i];
  return m;
}

float[] matrixToArray(matrix m1) {
  int k = 0;
  float[] array = new float[m1.rows * m1.cols];
  for (int i = 0; i < m1.rows; i++)
    for (int j = 0; j < m1.cols; j++) {
      array[k] = m1.m[i][j];
      k++;
    }
  return array;
}

String matrixToString(matrix m1) {
  String s = "";
  s += join(nf(matrixToArray(m1)), " ");
  return s;
}

float sigmoid(float x) {
  return 1 / (1 + exp(-x));
}

float dSigmoid(float x) {
  return x * (1 - x);
}
