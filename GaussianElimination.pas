uses Cmd;
uses Matrix;

const
  matrixRowsAmount: integer = 3;
  matrixColumnsAmount: integer = 4;

var
  matrix: array[,] of real;
  resultMatrix: array[,] of real;
  extendedResultMatrix: ExtendedMatrix;
  tempMatrix: array[,] of real;
  basicElementIndexes: (integer, integer);
  matrixTransformationCount: integer;
  matrixExample1 := new real[3, 5] (
    (4.0,  1.0,  2.0,  1.0, 0.0),
    (6.0,  1.0,  1.0,  0.0, 1.0),
    (10.0, 1.0, -1.0, -2.0, 3.0)
  );
  
  extendedMatrixExample1: ExtendedMatrix := (
    baseMatrix: matrixExample1;
    rowX: new string[4] ('-x1', '-x2', '-x3', '-x4');
    columnX: new string[3] ('0=', '0=', '0=');
  );
  
  matrixExample2 := new real[3, 4] (
    (1.0, 1.0, 2.0,  3.0),
    (1.0, 1.0, 1.0,  1.0),
    (2.0, 1.0, 0.0, -1.0)
  );
  
  extendedMatrixExample2: ExtendedMatrix := (
    baseMatrix: matrixExample2;
    rowX: new string[3] ('-x1', '-x2', '-x3');
    columnX: new string[3] ('0=', '0=', '0=');
  );

begin
  extendedResultMatrix := extendedMatrixExample1;
  
  Writeln('Исходная матрица');
  extendedResultMatrix.Print();
  
  var rank := rank(copyMatrix(extendedResultMatrix.baseMatrix));
  Writeln('Ранг матрицы = ', rank);
  matrixTransformationCount := 0;
  while (true) do
  begin
    Writeln('Введите индекс разрешающего элемента в формате "i j" (без кавычек)');
    basicElementIndexes := readBasicElementIndexes();
    Writeln(
      'Разрешающий элемент = ',
      extendedResultMatrix.baseMatrix[basicElementIndexes[0], basicElementIndexes[1]]
    );
    
    tempMatrix := gaussianElimination(extendedResultMatrix.baseMatrix, basicElementIndexes);
    extendedResultMatrix.baseMatrix := deleteColumn(tempMatrix, basicElementIndexes[1]);
    
    extendedResultMatrix.columnX[basicElementIndexes[0]] := $'x{basicElementIndexes[1]}='; 
    extendedResultMatrix.rowX := extendedResultMatrix.rowX
                                  .Where((element, i) -> i <> basicElementIndexes[1] - 1).ToArray();
    
    matrixTransformationCount += 1;
    Writeln('Преобразование ', matrixTransformationCount);
    extendedResultMatrix.Print();
    Writeln('------------------------------------------------------------------');
    
    // проверка найден ли ответ
    // проверка противоречий
    for var i := 0 to extendedResultMatrix.baseMatrix.GetLength(0) - 1 do
      if (
        (rowSum(extendedResultMatrix.baseMatrix, i) - extendedResultMatrix.baseMatrix[i, 0] = 0)
        and (extendedResultMatrix.baseMatrix[i, 0] <> 0)
      ) then
      begin
        Writeln('Нет решений');
        exit;
      end;
      
    if (matrixTransformationCount >= rank) then
    begin
      for var i := 0 to extendedResultMatrix.baseMatrix.GetLength(0) do
        if (extendedResultMatrix.columnX[i] = '0=') then
        begin
          if (rowSum(extendedResultMatrix.baseMatrix, i) = 0) then
          begin
            Writeln('Ответ:');
            printAnswer(extendedResultMatrix);
            exit;
          end;
        end;
    end;
  end;
end.