procedure printMatrix(matrix: array[,] of real);
begin
  for var i := 0 to Length(matrix, 0) - 1 do
  begin
    for var j := 0 to Length(matrix, 1) - 1 do
      Write(matrix[i, j]:7:2, ' ');
    Writeln();
  end;     
end;

function det(
  matrix: array[,] of real;
  topRow: integer;
  bottomRow: integer;
  leftColumn: integer;
  rightColumn: integer
): real;
begin
//  Assert(topRow > bottomRow);
//  Assert(leftColumn < rightColumn);
  Result := matrix[topRow, leftColumn] * matrix[bottomRow, rightColumn] -
            matrix[topRow, rightColumn] * matrix[bottomRow, leftColumn];
end;

function findFirsNonZeroElementIndexes(matrix: array[,] of real): (integer, integer);
begin
  for var i := 0 to Length(matrix, 0) - 1 do
    for var j := 0 to Length(matrix, 1) - 1 do
      if (matrix[i,j] <> 0.0) then
      begin
        Result := (i, j);
        exit;
      end;       
end;

function gaussianElimination(matrix: array[,] of real): array[,] of real;
var
  baseElementRow: integer;
  baseElementColumn: integer;
  baseElement: real;
begin
  Result := new real[Length(matrix, 0), Length(matrix, 1)];
  (baseElementRow, baseElementColumn) := findFirsNonZeroElementIndexes(matrix);
  baseElement := matrix[baseElementRow, baseElementColumn];
  
  // заполнение всей матрицы значениями 1 / разр. эл-т * определитель
  for var i := 0 to Length(matrix, 0) - 1 do
    for var j := 0 to Length(matrix, 1) - 1 do
      Result[i,j] := det(matrix, i, baseElementRow, j, baseElementColumn) /
                     baseElement;

  // заполнение строки                     
  for var i := 0 to Length(matrix, 1) - 1 do
    Result[baseElementRow, i] := -matrix[baseElementRow, i] / baseElement;
  
  // заполнение столбца
  for var i := 0 to Length(matrix, 0) - 1 do
    Result[i, baseElementColumn] := matrix[i, baseElementColumn] / baseElement;
  
  // вычисление элемента на месте разрешающего элемента
  Result[baseElementRow, baseElementColumn] := 1 / baseElement;
end;


const
  matrixRowsAmount: integer = 3;
  matrixColumnsAmount: integer = 4;

var
  matrix: array[,] of real;
  resultMatrix: array[,] of real;

begin
  matrix := new real[matrixRowsAmount, matrixColumnsAmount](
    (1.0, 2.0, 3.0, 4.0),
    (8.0, 4.0, 2.0, 1.0),
    (3.0, 5.0, 2.0, 4.0)
  );
  
  Writeln('Исходная матрица');
  printMatrix(matrix);
  
  resultMatrix := gaussianElimination(matrix);
  Writeln('Результат');
  printMatrix(resultMatrix);
end.