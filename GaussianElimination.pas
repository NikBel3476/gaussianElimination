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
  matrixTransformationCount: integer;

begin
//  matrix := new real[matrixRowsAmount, matrixColumnsAmount](
//    (1.0, 2.0, 3.0, 4.0),
//    (8.0, 4.0, 2.0, 1.0),
//    (3.0, 5.0, 2.0, 4.0)
//  );
  
  var matrixExample1 := new real[3, 5] (
    (4.0,  1.0,  2.0,  1.0, 0.0),
    (6.0,  1.0,  1.0,  0.0, 1.0),
    (10.0, 1.0, -1.0, -2.0, 3.0)
  );
  
  var extendedMatrixExample1: ExtendedMatrix := (
    baseMatrix: matrixExample1;
    rowX: new string[4] ('-x1', '-x2', '-x3', '-x4');
    columnX: new string[3] ('0=', '0=', '0=');
  );
  
  extendedMatrixExample1.Print();
  
  var matrixExample2 := new real[3, 4] (
    (1.0, 1.0, 2.0,  3.0),
    (1.0, 1.0, 1.0,  1.0),
    (2.0, 1.0, 0.0, -1.0)
  );
  
  Writeln('Rank: ', rank(matrixExample1));
  
  resultMatrix := matrixExample2;
  
  Writeln('Исходная матрица');
  printMatrix(resultMatrix);
  
  matrixTransformationCount := 0;
  while (true) do
  begin
    Writeln('Введите индекс разрешающего элемента в формате "i j" (без кавычек)');
    basicElementIndexes := readBasicElementIndexes();
    Writeln('Разрешающий элемент = ', matrixExample1[basicElementIndexes[0], basicElementIndexes[1]]);
    
    tempMatrix := gaussianElimination(resultMatrix, basicElementIndexes);
    resultMatrix := deleteColumn(tempMatrix, basicElementIndexes[1]);
    
    matrixTransformationCount += 1;
    Writeln('Преобразование ', matrixTransformationCount);
    printMatrix(resultMatrix);
    Writeln('------------------------------------------------------------------');
    
    
    // проверка найден ли ответ
//    for var i := 0 to Length(matrix, 0) - 1 do
//      for var j := 1 to Length(matrix, 0) - 1 do
//      begin
//        
//      end;
  end;
end.