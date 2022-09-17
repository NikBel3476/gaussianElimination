uses Cmd;
uses Matrix;

const
  matrixRowsAmount: integer = 3;
  matrixColumnsAmount: integer = 4;

var
  matrix: array[,] of real;
  resultMatrix: array[,] of real;
  tempMatrix: array[,] of real;
  basicElementIndexes: (integer, integer);

begin
//  matrix := new real[matrixRowsAmount, matrixColumnsAmount](
//    (1.0, 2.0, 3.0, 4.0),
//    (8.0, 4.0, 2.0, 1.0),
//    (3.0, 5.0, 2.0, 4.0)
//  );
  
  var matrixExample1 := new real[3, 4] (
    (1.0,  2.0,  1.0, 0.0),
    (1.0,  1.0,  0.0, 1.0),
    (1.0, -1.0, -2.0, 3.0)
  );
  
  Writeln('Исходная матрица');
  printMatrix(matrixExample1);
  
  Writeln('Введите индекс разрешающего элемента в формате "i j" (без кавычек)');
  basicElementIndexes := readBasicElementIndexes();
  Writeln('Разрешающий элемент = ', matrixExample1[basicElementIndexes[0], basicElementIndexes[1]]);
  
  tempMatrix := gaussianElimination(matrixExample1, basicElementIndexes);
  resultMatrix := deleteColumn(tempMatrix, basicElementIndexes[1]);
  
  Writeln('Преобразование 1');
  printMatrix(resultMatrix);
end.