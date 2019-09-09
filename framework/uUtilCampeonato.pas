unit uUtilCampeonato;

interface

uses System.Generics.Collections;

type
  TStatus = (tsAguardando, tsAndamento, tsFinalizado);

  TPlayer = record
    ID: Integer;
    Nome: string;
  end;

  TEquipe = record
    ID: Integer;
    Nome: string;
  end;

  TPontuacao = record
    Ponto11: Integer;
    Ponto12: Integer;
    Ponto13: Integer;
    Ponto21: Integer;
    Ponto22: Integer;
    Ponto23: Integer;
  end;

  TRodada = record
    ID: Integer;
    Descricao: string;
    Observacao: string;
    Status: TStatus;
  end;

  TPartida = record
    ID: Integer;
    Rodada: TRodada;
    Equipe1: TEquipe;
    Equipe2: TEquipe;
    Pontuacao: TPontuacao;
    Status: TStatus;
  end;

  TPontuacaoPlayer = record
    Player: TPlayer;
    Partida: TPartida;
    Kill: Integer;
    Death: Integer;
  end;
  
implementation

{ TPartida }

end.
