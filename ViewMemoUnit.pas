unit ViewMemoUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  Forms,
  SysUtils,
  Controls,
  StdCtrls;

type

  { TPrevForm }

  TPrevForm = class(TForm)
    CloseBut: TButton;
    Memo: TMemo;
    procedure CloseButClick(Sender: TObject);
  private
    procedure LoadMemoFromMemoryStream(Stream: TMemoryStream);
  public
    constructor Create(app: TComponent; title: string; mstream: TMemoryStream);
      reintroduce;
    constructor Create(app: TComponent; title: string; s: string); reintroduce;
  end;

implementation

{$R *.lfm}

procedure TPrevForm.CloseButClick(Sender: TObject);
begin
  Close;
end;

constructor TPrevForm.Create(app: TComponent; title: string; mstream: TMemoryStream);
begin
  inherited Create(app);
  Self.Caption := title;
  LoadMemoFromMemoryStream(mstream);
end;

constructor TPrevForm.Create(app: TComponent; title: string; s: string);
begin
  inherited Create(app);
  Self.Caption := title;
  Memo.Append(s);
end;

procedure TPrevForm.LoadMemoFromMemoryStream(Stream: TMemoryStream);
var
  p, q, r: PChar;
begin
  p := Stream.Memory;
  q := p + Stream.Size;// -1; fixed by Shay Horovitz
  r := p;
  while (p <> nil) and (p < q) do
  begin
    while (p < q) and (p^ <> #13) and (p^ <> #10) do
      Inc(p);
    Memo.Lines.Add(Copy(StrPas(r), 1, p - r));
    if (p[0] = #13) and (p[1] = #10) then
      Inc(p, 2)
    else
      Inc(p);
    r := p;
  end;
end;


end.
