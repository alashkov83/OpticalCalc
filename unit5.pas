unit Unit5;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  Forms,
  SysUtils,
  Controls,
  StdCtrls,
  Unit4;

type

  { TPrevForm }

  TPrevForm = class(TForm)
    CloseBut: TButton;
    Memo: TMemo;
    procedure CloseButClick(Sender: TObject);
  private

  public
    constructor Create(app: TComponent; mstream: TMemoryStream); reintroduce;
  end;

implementation

{$R *.lfm}

procedure TPrevForm.CloseButClick(Sender: TObject);
begin
  Close;
end;

  constructor TPrevForm.Create(app: TComponent; mstream: TMemoryStream);
  begin
    inherited Create(app);
    LoadMemoFromMemoryStream(Memo, mstream);
  end;

end.

