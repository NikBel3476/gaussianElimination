unit Cmd;

interface
procedure printMatrix(matrix: array[,] of real);
function readBasicElementIndexes(): (integer, integer);

implementation

procedure printMatrix(matrix: array[,] of real);
begin
  for var i := 0 to Length(matrix, 0) - 1 do
  begin
    for var j := 0 to Length(matrix, 1) - 1 do
      Write(matrix[i, j]:7:2, ' ');
    Writeln();
  end;     
end;

function readBasicElementIndexes(): (integer, integer);
var
  a, b: integer;
begin
  Readln(a, b);
  Result := (a, b);
end;
  
end.