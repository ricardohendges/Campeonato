unit uUtilDB;

interface

  uses FireDAC.Comp.Client;

  function GetNewSequence(ASeq: string): Integer;
  function GetConsulta(ASQL: string): TFDQuery;

implementation

uses dmConexao;

function GetNewSequence(ASeq: string): Integer;
var
  vQuery: TFDQuery;
begin
  vQuery := TFDQuery.Create(nil);
  try
    vQuery.Connection := Conexao.FDConexao;
    vQuery.Open('SELECT GEN_ID(' + ASeq + ',1) AS SEQ FROM RDB$DATABASE');
    Result := vQuery.FieldByName('SEQ').AsInteger;
  finally
    vQuery.Free;
  end;
end;

function GetConsulta(ASQL: string): TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  Result.Connection := Conexao.FDConexao;
  Result.Open(ASQL);
end;

end.
