unit Matrix;

interface

function det(
  matrix: array[,] of real;
  topRow: integer;
  bottomRow: integer;
  leftColumn: integer;
  rightColumn: integer
): real;
function findFirsNonZeroElementIndexes(matrix: array[,] of real): (integer, integer);
function gaussianElimination(matrix: array[,] of real; baseElementIndexes: (integer, integer)): array[,] of real;
function deleteColumn(matrix: array[,] of real; column: integer): array[,] of real;

implementation

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

function gaussianElimination(matrix: array[,] of real; baseElementIndexes: (integer, integer)): array[,] of real;
var
  baseElementRow: integer;
  baseElementColumn: integer;
  baseElement: real;
begin
  Result := new real[Length(matrix, 0), Length(matrix, 1)];
  (baseElementRow, baseElementColumn) := baseElementIndexes;
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

function deleteColumn(matrix: array[,] of real; column: integer): array[,] of real;
begin
  Result := new real[matrix.GetLength(0), matrix.GetLength(1) - 1];
  
  for var i := 0 to matrix.GetLength(0) - 1 do
    for var j := 0 to matrix.GetLength(1) - 2 do
      if (j >= column) then
        Result[i, j] := matrix[i, j + 1]
      else
        Result[i, j] := matrix[i, j];
end;

end.