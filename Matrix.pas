unit Matrix;

interface

type ExtendedMatrix = record
  baseMatrix: array[,] of real;
  rowX: array of string;
  columnX: array of string;
  public
    constructor Create(
      baseMatrix: array[,] of real;
      rowX: array of string;
      columnX: array of string
    );
    begin
      Self.baseMatrix := baseMatrix;
      Self.rowX := rowX;
      Self.columnX := columnX;
    end;
    procedure Print;
    procedure GaussianElimination(pivotIndexes: (integer, integer));
    procedure DeleteColumn(index: integer);
end;

function copyMatrix(matrix: array[,] of real): array[,] of real;
function rowSum(matrix: array[,] of real; row: integer): real;
function det(
  matrix: array[,] of real;
  topRow: integer;
  bottomRow: integer;
  leftColumn: integer;
  rightColumn: integer
): real;
function findFirstNonZeroElementIndexes(matrix: array[,] of real): (integer, integer);
function gaussianElimination(
  matrix: array[,] of real;
  baseElementIndexes: (integer, integer)
): array[,] of real;
function deleteColumn(matrix: array[,] of real; column: integer): array[,] of real;
procedure rowSwap(matrix: array[,] of real; row1, row2: integer; column: integer);
function rank(matrix: array[,] of real): integer;
procedure printAnswer(matrix: ExtendedMatrix);

implementation

procedure ExtendedMatrix.Print;
var charSpace: integer := 7;
begin
  Write('':charSpace, '│', '1':charSpace, '│');
  foreach var val in self.rowX do
    Write(val:charSpace);
  Writeln();
  Writeln('————————————————————————————————————————————');
  for var i := 0 to Length(self.baseMatrix, 0) - 1 do
  begin
    Write(self.columnX[i]:charSpace, '│');
    Write(self.baseMatrix[i, 0]:charSpace:2, '│');
    for var j := 1 to Length(self.baseMatrix, 1) - 1 do
      Write(self.baseMatrix[i, j]:charSpace:2);
    Writeln();
  end;
end;

procedure ExtendedMatrix.GaussianElimination(pivotIndexes: (integer, integer));
var
  pivotRow, pivotColumn: integer;
  pivot: real;
begin
  (pivotRow, pivotColumn) := pivotIndexes;
  pivotColumn += 1; // первый столбец содержит левую часть уравнения
  pivot := self.baseMatrix[pivotRow, pivotColumn];
  var newMatrix := new real[Length(self.baseMatrix, 0) - 1, Length(self.baseMatrix, 1) - 1];
  
  // заполнение всей матрицы значениями 1 / разр-ий эл-т * определитель
  for var i := 0 to Length(self.baseMatrix, 0) - 1 do
    for var j := 0 to Length(self.baseMatrix, 1) - 1 do
      newMatrix[i,j] := det(self.baseMatrix, i, pivotRow, j, pivotColumn) / pivot;

  // заполнение строки                     
  for var i := 0 to Length(self.baseMatrix, 1) - 1 do
    newMatrix[pivotRow, i] := self.baseMatrix[pivotRow, i] / pivot;
  
  // заполнение столбца
  for var i := 0 to Length(self.baseMatrix, 0) - 1 do
    newMatrix[i, pivotColumn] := -self.baseMatrix[i, pivotColumn] / pivot;
  
  // вычисление элемента на месте разрешающего элемента
  newMatrix[pivotRow, pivotColumn] := 1 / pivot;
end;

procedure ExtendedMatrix.DeleteColumn(index: integer);
begin
  
end;

function copyMatrix(matrix: array[,] of real): array[,] of real;
var
  rowsAmount := matrix.GetLength(0);
  columnsAmount := matrix.GetLength(1);
begin
  Result := new real[rowsAmount, columnsAmount];
  for var i := 0 to rowsAmount - 1 do
    for var j := 0 to columnsAmount - 1 do
      Result[i,j] := matrix[i,j];
end;

function rowSum(matrix: array[,] of real; row: integer): real;
begin
  Result := 0;
  for var i := 0 to matrix.GetLength(1) - 1 do
    Result += matrix[row, i];
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

function findFirstNonZeroElementIndexes(matrix: array[,] of real): (integer, integer);
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
    Result[baseElementRow, i] := matrix[baseElementRow, i] / baseElement;
  
  // заполнение столбца
  for var i := 0 to Length(matrix, 0) - 1 do
    Result[i, baseElementColumn] := -matrix[i, baseElementColumn] / baseElement;
  
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

procedure rowSwap(matrix: array[,] of real; row1, row2: integer; column: integer);
var
  temp: real;
begin
  for var i := 0 to column do
  begin
    temp := matrix[row1,i];
    matrix[row1,i] := matrix[row2,i];
    matrix[row2,i] := temp;
  end;
end;

function rank(matrix: array[,] of real): integer;
var
  rowsAmount := matrix.GetLength(0);
  columnsAmount := matrix.GetLength(1);
begin
  var rank := Min(rowsAmount, columnsAmount);
  
  var row := 0;
  while (row < rank) do
  begin
    // Диагональный элемент не равен 0
    if (matrix[row,row] <> 0) then
    begin
      for var col := 0 to rowsAmount - 1 do
        if (col <> row) then
        begin
          var mult := matrix[col,row] / matrix[row,row];
          for var i := 0 to rank do
            matrix[col,i] -= mult * matrix[row,i];
        end;
        
      row += 1;
    end
    else
    begin
      var reduce := true;
      
      for var i := row + 1 to rowsAmount - 1 do
        if (matrix[i,row] <> 0) then
        begin
          rowSwap(matrix, row, i, rank);
          reduce := false;
          break;
        end;
        
      if (reduce) then
      begin
        rank -= 1;
        
        for var i := 0 to rowsAmount - 1 do
          matrix[i,row] := matrix[i,rank];
      end;
    end
  end;
  
  Result := rank;
end;

procedure printAnswer(matrix: ExtendedMatrix);
var
  currentSymbolAscii := 97;
  rootSymbols: array of char;
begin
  rootSymbols := new char[matrix.rowX.Length];
  for var i := 0 to matrix.rowX.Length - 1 do
  begin
    rootSymbols[i] := char(currentSymbolAscii + i);
    Writeln(matrix.rowX[i].Substring(1), '= ', rootSymbols[i]);
  end;
  for var i := 0 to matrix.columnX.Length - 1 do
    if (matrix.columnX[i] <> '0=') then
    begin
      Write(matrix.columnX[i], ' ', matrix.baseMatrix[i, 0], ' ');
      for var j := 1 to matrix.baseMatrix.GetLength(1) - 1 do
      begin
        var matrixElement := -matrix.baseMatrix[i, j];
        if (matrixElement = -1) then
          Write('-')
        else
          Write(matrixElement);
        Write(rootSymbols[j - 1], ' ');
      end;
      Writeln();
    end;
end;  
end.