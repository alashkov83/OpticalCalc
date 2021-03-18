{
  OpticalCalc
  Util designed to improve measurements of optical characteristics
  of samples on spectrophotometric devices.

  Copyright (C) 2020 Lashkov A., Nabatov B., e-mail: alashkov83@gmail.com

  This source is free software; you can redistribute it and/or modify it under
  the terms of the GNU General Public License as published by the Free
  Software Foundation; either version 2 of the License, or (at your option)
  any later version.

  This code is distributed in the hope that it will be useful, but WITHOUT ANY
  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
  details.

  A copy of the GNU General Public License is available on the World Wide Web
  at <http://www.gnu.org/copyleft/gpl.html>. You can also obtain it by writing
  to the Free Software Foundation, Inc., 51 Franklin Street - Fifth Floor,
  Boston, MA 02110-1335, USA.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  OpticalCalc - сервисная программа, предназначенная для повышение удобства
  измерения оптических характеристик образцов на спектрофотометрических приборах.

  © 2020 Лашков А., Набатов Б., e-mail: alashkov83@gmail.com

  Данная программа является свободным
  программным обеспечением. Вы вправе
  распространять её и/или модифицировать в
  соответствии с условиями версии 2 либо по
  вашему выбору с условиями более поздней
  версии Стандартной Общественной
  Лицензии GNU, опубликованной Free Software Foundation.

  Мы распространяем эту программу в
  надежде на то, что она будет вам полезной,
  однако НЕ ПРЕДОСТАВЛЯЕМ НА НЕЁ НИКАКИХ
  ГАРАНТИЙ, в том числе ГАРАНТИИ ТОВАРНОГО
  СОСТОЯНИЯ ПРИ ПРОДАЖЕ и ПРИГОДНОСТИ ДЛЯ
  ИСПОЛЬЗОВАНИЯ В КОНКРЕТНЫХ ЦЕЛЯХ. Для
  получения более подробной информации
  ознакомьтесь со Стандартной
  Общественной Лицензией GNU.

  Копия Стандартной Общественной Лицензии
  GNU доступна в Интернете по адресу
  <http://www.gnu.org/copyleft/gpl.html>. Вы также можете
  получить экземпляр в Free Software Foundation, Inc., 51
  Franklin Street - Fifth Floor, Boston, MA 02110-1335, USA.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
}

unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  Forms,
  Dialogs,
  StdCtrls,
  ExtCtrls,
  Menus,
  csvreadwrite,
  Math,
  LCLType,
  Spin,
  Unit3,
  Unit5,
  Unit4;

type
  XYList = ^TXYList;

  TXYList = record
    X: extended;
    Y: extended;
    Next: XYList;
  end;

  { TConvertForm }

  TConvertForm = class(TForm)
    AnFBut: TButton;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    SpinEdit3: TSpinEdit;
    SpinEdit4: TSpinEdit;
    XCBox: TComboBox;
    PrevBut: TButton;
    CancelBut: TButton;
    InMesYFld: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    OKBut: TButton;
    InMesXFld: TEdit;
    OpnFileDlg: TOpenDialog;
    YCBox: TComboBox;
    YAbsRRBut: TRadioButton;
    SvFileDlg: TSaveDialog;
    XIgnRBut: TRadioButton;
    XNmRBut: TRadioButton;
    XCmRBut: TRadioButton;
    XEVRBut: TRadioButton;
    YIgnRBut: TRadioButton;
    YTRBut: TRadioButton;
    YDRBut: TRadioButton;
    YRRBut: TRadioButton;
    YFrRbut: TRadioButton;
    XRGroup: TRadioGroup;
    YRGroup: TRadioGroup;
    procedure AnFButClick(Sender: TObject);
    procedure CancelButClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure MenuItem6Click(Sender: TObject);
    procedure OKButClick(Sender: TObject);
    procedure PrevButClick(Sender: TObject);
  private
    FInName: string;
    InList: XYList;
    CSVheader: string;
    OutList: XYList;
    InMesX: byte;
    InMesY: byte;
    procedure clearList(var list: XYList);
    procedure addElemList(var list: XYList; x, y: extended);
    function parseFile(fname: string; var list: XYList; var header: string;
      var mesx: byte; var mesy: byte): byte;
    procedure checkRadioBtn(var outmesx: byte; var outmesy: byte);
    procedure showMessure(mesx, mesy: byte);
    procedure setRadBtns(mesx, mesy: byte);
    function convertMes(mesx, mesy, outmesx, outmesy: byte; nstep: integer): byte;
    function writeCSVFile(header: string; mesx, mesy, outmesx, outmesy: byte;
      list: XYList; filename: string; mstream: TMemoryStream): byte;
  public
    constructor Create(app: TComponent; FName: string); reintroduce;
    destructor Destroy; override;
  end;

  EStrToFloutException = class(Exception);

const
  hc: extended = 1239.841984;

implementation

{$R *.lfm}

{ TConvertForm }

constructor TConvertForm.Create(app: TComponent; FName: string);
begin
  inherited Create(app);
  CSVheader := '';
  FInName := FName;
  InList := nil;
  OutList := nil;
  InMesX := 0;
  InMesY := 0;
  OpnFileDlg.InitialDir := GetCurrentDir;
  SvFileDlg.InitialDir := GetCurrentDir;
  XCBox.ItemIndex := 0;
  YCBox.ItemIndex := 0;
  if FInName <> '' then
  begin
    if parseFile(FInName, InList, CSVheader, InMesX, InMesY) <> 0 then
    begin
      ShowError('Ошибка разбора файла: ' + FInName);
      CSVheader := '';
      InMesX := 0;
      InMesY := 0;
      clearList(InList);
    end;
  end;
  showMessure(InMesX, InMesY);
  setRadBtns(InMesX, InMesY);
end;

destructor TConvertForm.Destroy;
begin
  clearList(InList);
  clearList(OutList);
  inherited;
end;

procedure TConvertForm.AnFButClick(Sender: TObject);
begin
  if OpnFileDlg.Execute then
  begin
    FInName := OpnFileDlg.Filename;
    clearList(InList);
    if parseFile(FInName, InList, CSVheader, InMesX, InMesY) <> 0 then
    begin
      ShowError('Ошибка разбора файла: ' + FInName);
      CSVheader := '';
      InMesX := 0;
      InMesY := 0;
      clearList(InList);
    end;
    showMessure(InMesX, InMesY);
    setRadBtns(InMesX, InMesY);
  end;
end;

procedure TConvertForm.CancelButClick(Sender: TObject);
begin
  Close;
end;

procedure TConvertForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := caFree;
end;

procedure TConvertForm.MenuItem6Click(Sender: TObject);
var
  showshchema: TShowSchemaForm;
begin
  showshchema := TShowSchemaForm.Create(Self);
  //converter.left := 100;
  //converter.top := 100;
  showshchema.Caption := 'Схема конвертации';
  showshchema.SLabel.Caption :=
    '                  /-> F(R)' + #10 + 'Abs <-> %T = %R <-' + #10 +
    '                  \-> Absolute_%R';

  showshchema.ShowModal;
  showshchema.Free; //иначе будет утечка памяти
end;


procedure TConvertForm.OKButClick(Sender: TObject);
var
  outmesx, outmesy: byte;
begin
  outmesx := 0;
  outmesy := 0;
  if InList = nil then
  begin
    ShowError('Cписок входных данных пуст!');
  end
  else
  begin
    clearList(OutList);
    checkRadioBtn(outmesx, outmesy);
    if (convertMes(InMesX, InMesY, outmesx, outmesy, 0) = 0) then
    begin
      ShowInfo('Преобразование прошло успешно!');
    end
    else
    begin
      ShowWarning('Во время преобразования были ошибки!');
    end;
    SvFileDlg.Filename := FInName;
    if SvFileDlg.Execute then
    begin
      if writeCSVFile(CSVHeader, InMesX, InMesY, outmesx, outmesy,
        OutList, SvFileDlg.Filename, nil) = 0 then
      begin
        ShowInfo('Файл ' + SvFileDlg.Filename +
          ' успешно сохранён!');
      end;
    end;
  end;
end;

procedure TConvertForm.PrevButClick(Sender: TObject);
var
  mstream: TMemoryStream;
  showprev: TPrevForm;
  outmesx, outmesy: byte;
begin
  mstream := nil;
  outmesx := 0;
  outmesy := 0;
  if InList = nil then
  begin
    ShowError('Cписок входных данных пуст!');
  end
  else
  begin
    clearList(OutList);
    checkRadioBtn(outmesx, outmesy);
    if (convertMes(InMesX, InMesY, outmesx, outmesy, 10) <> 0) then
      ShowWarning('Во время преобразования были ошибки!');
    mstream := TMemoryStream.Create;
    if mstream <> nil then
    begin
      if writeCSVFile(CSVHeader, InMesX, InMesY, outmesx, outmesy,
        OutList, '', mstream) = 0 then
      begin
        showprev := TPrevForm.Create(Self, mstream);
        showprev.ShowModal;
        showprev.Free; //иначе будет утечка памяти
      end;
    mstream.Free;
    end;
  end;
end;

procedure TConvertForm.addElemList(var list: XYList; x, y: extended);
var
  tmp: XYList;
begin
  New(tmp);
  tmp^.X := x;
  tmp^.Y := y;
  tmp^.Next := list;
  list := tmp;
end;

procedure TConvertForm.clearList(var list: XYList);
var
  tmp: XYList;
begin
  while list <> nil do
    {пока list не станет указывать в "пустоту" делать}
  begin
    tmp := list; {указатель tmp направим на вершину стека}
    list := list^.Next;
    {вершину стека перенесём на следующий за данной вершиной элемент}
    Dispose(tmp);
    {освободим память занятую под старую вершину}
  end;
  list := nil;
end;

function TConvertForm.parseFile(fname: string; var list: XYList;
  var header: string; var mesx: byte; var mesy: byte): byte;
var
  FileStream: TFileStream;
  Parser: TCSVParser;
  err: integer;
  flag: byte;
  str: string;
  x, y: extended;
begin
  flag := 0;
  err := 0;
  Parser := TCSVParser.Create;
  FileStream := TFileStream.Create(fname, fmOpenRead + fmShareDenyWrite);
  try
    try
      Parser.Delimiter := ',';
      Parser.SetSource(FileStream);
      while Parser.ParseNextCell do
      begin
        str := Parser.CurrentCellText;
        if Parser.CurrentRow = 0 then
        begin
          if Parser.CurrentCol = 0 then
            header := str;
        end
        else if Parser.CurrentRow = 1 then
        begin
          if Parser.CurrentCol = 0 then
          begin
            if pos('(nm)', str) <> 0 then
              mesx := 1
            else if pos('(cm-1)', str) <> 0 then
              mesx := 2
            else if pos('(eV)', str) <> 0 then
              mesx := 3
            else if pos('(min)', str) <> 0 then
              mesx := 4
            else
              mesx := 0;
          end
          else if Parser.CurrentCol = 1 then
          begin
            if pos('%T', str) <> 0 then
              mesy := 1
            else if pos('Absolute', str) <> 0 then
              mesy := 5
            else if pos('Abs', str) <> 0 then
              mesy := 2
            else if pos('%R', str) <> 0 then
              mesy := 3
            else if pos('F(R)', str) <> 0 then
              mesy := 4
            else
              mesy := 0;
          end;
        end
        else
        begin
          if Parser.CurrentCol = 0 then
          begin
            if str = '' then
              break;
            flag := 1;
            Val(str, x, err);
            if err <> 0 then
              raise EStrToFloutException.Create(
                'Ошибка преобразования строки:' + str);
          end
          else if Parser.CurrentCol = 1 then
          begin
            flag := 2;
            Val(str, y, err);
            if err <> 0 then
              raise EStrToFloutException.Create(
                'Ошибка преобразования строки:' + str);
          end
          else
          begin
            flag := 0;
          end;
          if (flag = 2) then
            addElemList(list, x, y);
        end;
      end;
      Result := 0;
    except
      On E: Exception do
      begin
        Result := 1;
        ShowError(E.Message);
      end;
    end;
  finally
    FileStream.Free;
    Parser.Free;
  end;
end;

procedure TConvertForm.setRadBtns(mesx, mesy: byte);
begin
  XIgnRBut.Enabled := True;
  XNmRBut.Enabled := True;
  XCmRBut.Enabled := True;
  XEVRBut.Enabled := True;
  XIgnRBut.Checked := True;
  YIgnRBut.Enabled := True;
  YTRBut.Enabled := True;
  YDRBut.Enabled := True;
  YRRBut.Enabled := True;
  YFrRbut.Enabled := True;
  YAbsRRBut.Enabled := True;
  YIgnRBut.Checked := True;
  case mesx of
    0, 4:
    begin
      XNmRBut.Enabled := False;
      XCmRBut.Enabled := False;
      XEVRBut.Enabled := False;
    end;
    1:
    begin
      XNmRBut.Enabled := False;
    end;
    2:
    begin
      XCmRBut.Enabled := False;
    end;
    3:
    begin
      XEVRBut.Enabled := False;
    end;
  end;
  case mesy of
    0:
    begin
      YTRBut.Enabled := False;
      YDRBut.Enabled := False;
      YRRBut.Enabled := False;
      YFrRbut.Enabled := False;
      YAbsRRBut.Enabled := False;
    end;
    1:
    begin
      YTRBut.Enabled := False;
    end;
    2:
    begin
      YDRBut.Enabled := False;
    end;
    3:
    begin
      YRRBut.Enabled := False;
    end;
    4:
    begin
      YFrRbut.Enabled := False;
    end;
    5:
    begin
      YAbsRRBut.Enabled := False;
    end
  end;
end;

procedure TConvertForm.showMessure(mesx, mesy: byte);
var
  xmes: array[1..4] of string = ('нм', 'см^-1', 'eV', 'мин');
  ymes: array[1..5] of string = ('T,%', 'D или Abs', 'R,%', 'F(R)', 'Absolute R, %');
begin
  if mesx = 0 then
    InMesXFld.Text := 'Unknown'
  else
    InMesXFld.Text := xmes[mesx];
  if mesy = 0 then
    InMesYFld.Text := 'Unknown'
  else
    InMesYFld.Text := ymes[mesy];
end;

function TConvertForm.convertMes(mesx, mesy, outmesx, outmesy: byte;
  nstep: integer): byte;
var
  err: byte;
  i: integer;
  xin, yin, xout, yout: double;
  tmplist: XYList;
begin
  i := 0;
  err := 0;
  tmplist := InList;
  while (tmplist <> nil) and ((nstep = 0) or ((nstep <> 0) and (i < nstep))) do
  begin
    xin := tmplist^.X;
    yin := tmplist^.Y;
    if (mesx = 1) and (outmesx = 2) then
    begin
      if xin <> 0.0 then
      begin
        xout := 1E7 / xin;
      end
      else
      begin
        xout := 0.0;
        err := 1;
      end;
    end
    else if (mesx = 1) and (outmesx = 3) then
    begin
      if xin <> 0.0 then
      begin
        xout := hc / xin;
      end
      else
      begin
        xout := 0.0;
        err := 1;
      end;
    end
    else if (mesx = 2) and (outmesx = 1) then
    begin
      if xin <> 0.0 then
      begin
        xout := 1E7 / xin;
      end
      else
      begin
        xout := 0.0;
        err := 1;
      end;
    end
    else if (mesx = 2) and (outmesx = 3) then
    begin
      xout := (hc / 1E7) * xin;
    end
    else if (mesx = 3) and (outmesx = 1) then
    begin
      if xin <> 0.0 then
      begin
        xout := hc / xin;
      end
      else
      begin
        xout := 0.0;
        err := 1;
      end;
    end
    else if (mesx = 3) and (outmesx = 2) then
    begin
      xout := (1E7 / hc) * xin;
    end
    else
    begin
      xout := xin;
    end;
    if (mesy = 1) and (outmesy = 2) then
    begin
      if (yin > 0.0) then
      begin
        yout := -1.0 * Log10(yin / 100);
      end
      else if (yin = 0.0) then
      begin
        yout := 99.0;
        err := 1;
      end
      else
      begin
        yout := 99.0;
        err := 1;
      end;
    end
    else if (mesy = 1) and (outmesy = 3) then
    begin
      yout := yin;
    end
    else if (mesy = 1) and (outmesy = 4) then
    begin
      if yin > 0.0 then
      begin
        yout := Power((1 - (yin / 100.0)), 2) / (2 * yin / 100.0);
      end
      else
      begin
        yout := 999.0;
      end;
    end
    else if (mesy = 1) and (outmesy = 5) then
    begin
      if (yin >= 0.0) then
      begin
        yout := sqrt(yin);
      end
      else
      begin
        yout := 0.0;
        err := 1;
      end;
    end
    else if (mesy = 2) and (outmesy = 1) then
    begin
      yout := 100 * Power(10, -1.0 * yin);
    end
    else if (mesy = 2) and (outmesy = 3) then
    begin
      yout := 100 * Power(10, -1.0 * yin);
    end
    else if (mesy = 2) and (outmesy = 4) then
    begin
      yout := 100 * Power(10, -1.0 * yin);
      if yout > 0.0 then
      begin
        yout := Power((1 - (yout / 100.0)), 2) / (2 * yout / 100.0);
      end
      else
      begin
        yout := 999.0;
      end;
    end
    else if (mesy = 2) and (outmesy = 5) then
    begin
      yout := 100 * Power(10, -1.0 * yin);
      if (yout >= 0.0) then
      begin
        yout := sqrt(yout);
      end
      else
      begin
        yout := 0.0;
        err := 1;
      end;
    end
    else if (mesy = 3) and (outmesy = 1) then
    begin
      yout := yin;
    end
    else if (mesy = 3) and (outmesy = 2) then
    begin
      if (yin > 0.0) then
      begin
        yout := -1.0 * Log10(yin / 100);
      end
      else
      begin
        yout := 99.0;
        err := 1;
      end;
    end
    else if (mesy = 3) and (outmesy = 4) then
    begin
      if (yin > 0.0) then
      begin
        yout := Power((1 - (yin / 100.0)), 2) / (2 * yin / 100.0);
      end
      else
      begin
        yout := 999.0;
        err := 1;
      end;
    end
    else if (mesy = 3) and (outmesy = 5) then
    begin
      if (yin >= 0.0) then
      begin
        yout := sqrt(yin);
      end
      else
      begin
        yout := 0.0;
        err := 1;
      end;
    end
    else if (mesy = 4) and (outmesy = 1) then
    begin
      yout := 100 * (1 + yin - sqrt(yin * yin + 2 * yin));
    end
    else if (mesy = 4) and (outmesy = 2) then
    begin
      yout := 100 * (1 + yin - sqrt(yin * yin + 2 * yin));
      if (yout > 0.0) then
      begin
        yout := -1.0 * Log10(yout / 100);
      end
      else
      begin
        yout := 99.0;
        err := 1;
      end;
    end
    else if (mesy = 4) and (outmesy = 3) then
    begin
      yout := 100 * (1 + yin - sqrt(yin * yin + 2 * yin));
    end
    else if (mesy = 4) and (outmesy = 5) then
    begin
      yout := 100 * (1 + yin - sqrt(yin * yin + 2 * yin));
      if (yout >= 0.0) then
      begin
        yout := sqrt(yout);
      end
      else
      begin
        yout := 0.0;
        err := 1;
      end;
    end
    else if (mesy = 5) and (outmesy = 1) then
    begin
      yout := yin * yin;
    end
    else if (mesy = 5) and (outmesy = 2) then
    begin
      if (yin <> 0.0) then
      begin
        yout := -1.0 * Log10(yin * yin / 100);
      end
      else
      begin
        yout := 99.0;
        err := 1;
      end;
    end
    else if (mesy = 5) and (outmesy = 3) then
    begin
      yout := yin * yin;
    end
    else if (mesy = 5) and (outmesy = 4) then
    begin
      if yin <> 0.0 then
      begin
        yout := Power((1 - (yin * yin / 100.0)), 2) / (2 * yin * yin / 100.0);
      end
      else
      begin
        yout := 999.0;
      end;
    end
    else
    begin
      yout := yin;
    end;
    addElemList(OutList, xout, yout);
    tmplist := tmplist^.Next;
    Inc(i);
  end;
  Result := err;
end;

procedure TConvertForm.checkRadioBtn(var outmesx: byte; var outmesy: byte);
begin
  if XIgnRBut.Checked then
    outmesx := 0;
  if XNmRBut.Checked then
    outmesx := 1;
  if XCmRBut.Checked then
    outmesx := 2;
  if XEVRBut.Checked then
    outmesx := 3;
  if YIgnRBut.Checked then
    outmesy := 0;
  if YTRBut.Checked then
    outmesy := 1;
  if YDRBut.Checked then
    outmesy := 2;
  if YRRBut.Checked then
    outmesy := 3;
  if YFrRbut.Checked then
    outmesy := 4;
  if YAbsRRBut.Checked then
    outmesy := 5;
end;

function TConvertForm.writeCSVFile(header: string; mesx, mesy, outmesx, outmesy: byte;
  list: XYList; filename: string; mstream: TMemoryStream): byte;
var
  FileStream: TFileStream;
  Builder: TCSVBuilder;
  resx, resy: byte;
  s: string;
  tmplist: XYList;
  x, y: extended;
  xmes: array[1..4] of string = ('Wavelength (nm)', 'Wavenumber (cm-1)',
    'Energy (eV)', 'Time (min)');
  ymes: array[1..5] of string = ('%T', 'Abs', '%R', 'F(R)', 'Absolute %R');
begin
  tmplist := list;
  if outmesx = 0 then
    resx := mesx
  else
    resx := outmesx;
  if outmesy = 0 then
    resy := mesy
  else
    resy := outmesy;
  Builder := TCSVBuilder.Create;
  if mstream = nil then
    FileStream := TFileStream.Create(filename, fmCreate + fmOpenWrite + fmShareDenyWrite);
  try
    try
      Builder.Delimiter := ',';
      if mstream = nil then
        Builder.SetOutput(FileStream)
      else
        Builder.SetOutput(mstream);
      Builder.ResetBuilder;
      Builder.AppendCell(header);
      Builder.AppendCell('');
      Builder.AppendCell('');
      Builder.AppendRow;
      if resx = 0 then
        s := 'Unknown'
      else
        s := xmes[resx];
      Builder.AppendCell(s);
      if resy = 0 then
        s := 'Unknown'
      else
        s := ymes[resy];
      Builder.AppendCell(s);
      Builder.AppendCell('');
      Builder.AppendRow;
      while tmplist <> nil do
      begin
        x := tmplist^.X;
        y := tmplist^.Y;
        case resx of
          0: Str(x, s);
          1: Str(x: 0: 1, s);
          2: Str(x: 0: 1, s);
          3: Str(x: 0: 4, s);
          4: Str(x: 0: 12, s);
        end;
        Builder.AppendCell(s);
        case resy of
          0: Str(y, s);
          1: Str(y: 0: 10, s);
          2: Str(y: 0: 10, s);
          3: Str(y: 0: 8, s);
          4: Str(y: 0: 10, s);
          5: Str(y: 0: 10, s);
        end;
        Builder.AppendCell(s);
        Builder.AppendCell('');
        Builder.AppendRow;
        tmplist := tmplist^.Next;
      end;
      Builder.AppendRow;
      Result := 0;
    except
      On E: Exception do
      begin
        Result := 1;
        ShowError(E.Message);
      end;
    end;
  finally
    Builder.Free;
    if mstream = nil then FileStream.Free;
  end;
end;

end.
