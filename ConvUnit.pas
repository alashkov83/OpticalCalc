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

unit ConvUnit;

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
  SchemaUnit,
  DialogsUnit,
  ViewMemoUnit,
  StringsUnit,
  ConstUnit;

type
  XYList = ^TXYList;

  TXYList = record
    X: extended;
    Y: extended;
    index: QWord;
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
    DigXSEdt: TSpinEdit;
    FNMemo: TMemo;
    MenuItem7: TMenuItem;
    PrecXSEdt: TSpinEdit;
    PrecYSEdt: TSpinEdit;
    DigYSEdt: TSpinEdit;
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
    procedure MenuItem7Click(Sender: TObject);
    procedure OKButClick(Sender: TObject);
    procedure PrevButClick(Sender: TObject);
    procedure ChangeFormatParams(Sender: TObject);
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
    function FormatVal(val: extended; format, prec, dig: integer): string;
  public
    constructor Create(app: TComponent; FName: string); reintroduce;
    destructor Destroy; override;
  end;

  EStrToFloutException = class(Exception);

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
  FNMemo.Lines.Clear;
  FNMemo.Lines.Add(FInName);
  ChangeFormatParams(nil);
  if FInName <> '' then
  begin
    if parseFile(FInName, InList, CSVheader, InMesX, InMesY) <> 0 then
    begin
      ShowError(ERR_PARSING_TEXT + FInName);
      CSVheader := '';
      InMesX := 0;
      InMesY := 0;
      FNMemo.Lines.Clear;
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
    FNMemo.Lines.Clear;
    FNMemo.Lines.Add(FInName);
    FNMemo.SelStart := 0;
    FNMemo.ReadOnly := true;
    if parseFile(FInName, InList, CSVheader, InMesX, InMesY) <> 0 then
    begin
      ShowError(ERR_PARSING_TEXT + FInName);
      CSVheader := '';
      InMesX := 0;
      InMesY := 0;
      FNMemo.Lines.Clear;
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
  showshchema.Caption := CONV_HELP_CAP_TEXT;
  showshchema.SLabel.Caption := CONV_SCHEMA_TEXT;
  showshchema.ShowModal;
  FreeAndNil(showshchema); //иначе будет утечка памяти
end;

procedure TConvertForm.MenuItem7Click(Sender: TObject);
var
  formathelp: TPrevForm;
  s: string;

begin
  s := FORMAT_HELP_TEXT;
  formathelp := TPrevForm.Create(Self, FORMAT_HELP_CAP_TEXT, s);
  formathelp.ShowModal;
  FreeAndNIl(formathelp); //иначе будет утечка памяти
end;


procedure TConvertForm.OKButClick(Sender: TObject);
var
  outmesx, outmesy: byte;
begin
  outmesx := 0;
  outmesy := 0;
  if InList = nil then
  begin
    ShowError(EMPTY_LIST_TEXT);
  end
  else
  begin
    clearList(OutList);
    checkRadioBtn(outmesx, outmesy);
    if (convertMes(InMesX, InMesY, outmesx, outmesy, 0) = 0) then
    begin
      ShowInfo(SUCCESS_CONV_TEXT);
    end
    else
    begin
      ShowWarning(WARN_CONV_TEXT);
    end;
    SvFileDlg.Filename := FInName;
    if SvFileDlg.Execute then
    begin
      if writeCSVFile(CSVHeader, InMesX, InMesY, outmesx, outmesy,
        OutList, SvFileDlg.Filename, nil) = 0 then
      begin
        ShowInfo(FILE_TEXT + ' ' + SvFileDlg.Filename + ' ' + SUC_SAVE_TEXT);
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
    ShowError(EMPTY_LIST_TEXT);
  end
  else
  begin
    clearList(OutList);
    checkRadioBtn(outmesx, outmesy);
    if (convertMes(InMesX, InMesY, outmesx, outmesy, 10) <> 0) then
      ShowWarning(WARN_CONV_TEXT);
    mstream := TMemoryStream.Create;
    if mstream <> nil then
    begin
      if writeCSVFile(CSVHeader, InMesX, InMesY, outmesx, outmesy,
        OutList, '', mstream) = 0 then
      begin
        showprev := TPrevForm.Create(Self, PREVIEW_TEXT, mstream);
        showprev.ShowModal;
        FreeAndNIl(showprev); //иначе будет утечка памяти
      end;
      FreeAndNil(mstream);
    end;
  end;
end;

procedure TConvertForm.ChangeFormatParams(Sender: TObject);
var
  formatx, formaty, digx, digy, precx, precy: integer;
begin
  formatx := XCBox.ItemIndex;
  formaty := YCBox.ItemIndex;
  digx := 1;
  digy := 1;
  if XIgnRBut.Checked then
  begin
    case formatx of
      0: precx := 6;
      1:
        case InMesX of
          0:
          begin
            precx := 6;
            digx := 5;
          end;
          1:
          begin
            precx := 6;
            digx := 2;
          end;
          2:
          begin
            precx := 5;
            digx := 2;
          end;
          3:
          begin
            precx := 2;
            digx := 4;
          end;
          4:
          begin
            precx := 3;
            digx := 5;
          end;
        end;
      2:
        case InMesX of
          0:
          begin
            precx := 6;
          end;
          1:
          begin
            precx := 3;
          end;
          2:
          begin
            precx := 3;
          end;
          3:
          begin
            precx := 6;
          end;
          4:
          begin
            precx := 6;
          end;
        end;
    end;
  end
  else if XNmRBut.Checked then
  begin
    case formatx of
      0:
      begin
        precx := 6;
      end;
      1:
      begin
        precx := 4;
        digx := 2;
      end;
      2:
      begin
        precx := 3;
      end;
    end;
  end
  else if XCmRBut.Checked then
  begin
    case formatx of
      0:
      begin
        precx := 6;
      end;
      1:
      begin
        precx := 5;
        digx := 2;
      end;
      2:
      begin
        precx := 3;
      end;
    end;
  end
  else if XEVRBut.Checked then
  begin
    case formatx of
      0:
      begin
        precx := 6;
      end;
      1:
      begin
        precx := 2;
        digx := 4;
      end;
      2:
      begin
        precx := 6;
      end;
    end;
  end;
  if YIgnRBut.Checked then
  begin
    case formaty of
      0: precy := 12;
      1:
        case InMesY of
          0:
          begin
            precy := 3;
            digy := 10;
          end;
          1:
          begin
            precy := 3;
            digy := 10;
          end;
          2:
          begin
            precy := 2;
            digy := 10;
          end;
          3:
          begin
            precy := 2;
            digy := 8;
          end;
          4:
          begin
            precy := 1;
            digy := 10;
          end;
          5:
          begin
            precy := 2;
            digy := 8;
          end;
        end;
      2:
        case InMesY of
          0:
          begin
            precy := 12;
          end;
          1:
          begin
            precy := 12;
          end;
          2:
          begin
            precy := 12;
          end;
          3:
          begin
            precy := 10;
          end;
          4:
          begin
            precy := 11;
          end;
          5:
          begin
            precy := 10;
          end;
        end;
    end;
  end
  else if YTRBut.Checked then
  begin
    case formaty of
      0:
      begin
        precy := 12;
      end;
      1:
      begin
        precy := 3;
        digy := 10;
      end;
      2:
      begin
        precy := 12;
      end;
    end;
  end
  else if YDRBut.Checked then
  begin
    case formaty of
      0:
      begin
        precy := 12;
      end;
      1:
      begin
        precy := 2;
        digy := 10;
      end;
      2:
      begin
        precy := 12;
      end;
    end;
  end
  else if YRRBut.Checked then
  begin
    case formaty of
      0:
      begin
        precy := 12;
      end;
      1:
      begin
        precy := 2;
        digy := 8;
      end;
      2:
      begin
        precy := 10;
      end;
    end;
  end
  else if YFrRbut.Checked then
  begin
    case formaty of
      0:
      begin
        precy := 11;
      end;
      1:
      begin
        precy := 1;
        digy := 10;
      end;
      2:
      begin
        precx := 11;
      end;
    end;
  end
  else if YAbsRRBut.Checked then
  begin
    case formaty of
      0:
      begin
        precy := 12;
      end;
      1:
      begin
        precy := 2;
        digy := 8;
      end;
      2:
      begin
        precy := 10;
      end;
    end;
  end;
  PrecXSEdt.Value := precx;
  PrecYSEdt.Value := precy;
  DigXSEdt.Value := digx;
  DigYSEdt.Value := digy;
  case formatx of
    0:
    begin
      XCBox.Hint := FMT_GEN_HINT_TEXT;
      PrecXSEdt.Hint := PREC_EXP_HINT_TEXT;
      DigXSEdt.Hint := DIG_EXP_HINT_TEXT;
    end;
    1:
    begin
      XCBox.Hint := FMT_FIX_HINT_TEXT;
      PrecXSEdt.Hint := PREC_FIX_HINT_TEXT;
      DigXSEdt.Hint := DIG_FIX_HINT_TEXT;
    end;
    2:
    begin
      XCBox.Hint := FMT_EXP_HINT_TEXT;
      PrecXSEdt.Hint := PREC_EXP_HINT_TEXT;
      DigXSEdt.Hint := DIG_EXP_HINT_TEXT;
    end;
  end;
  case formaty of
    0:
    begin
      YCBox.Hint := FMT_GEN_HINT_TEXT;
      PrecYSEdt.Hint := PREC_EXP_HINT_TEXT;
      DigYSEdt.Hint := DIG_EXP_HINT_TEXT;
    end;
    1:
    begin
      YCBox.Hint := FMT_FIX_HINT_TEXT;
      PrecYSEdt.Hint := PREC_FIX_HINT_TEXT;
      DigYSEdt.Hint := DIG_FIX_HINT_TEXT;
    end;
    2:
    begin
      YCBox.Hint := FMT_EXP_HINT_TEXT;
      PrecYSEdt.Hint := PREC_EXP_HINT_TEXT;
      DigYSEdt.Hint := DIG_EXP_HINT_TEXT;
    end;
  end;
  if formatx = 2 then
    DigXSEdt.MaxValue := 4
  else
    DigXSEdt.MaxValue := 12;
  if formaty = 2 then
    DigYSEdt.MaxValue := 4
  else
    DigYSEdt.MaxValue := 12;
end;

procedure TConvertForm.addElemList(var list: XYList; x, y: extended);
var
  tmp: XYList;
begin
  New(tmp);
  tmp^.X := x;
  tmp^.Y := y;
  if list = nil then tmp^.index := 1 else tmp^.index := list^.index + 1;
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
              raise EStrToFloutException.Create(ERR_CONV_LINE_TEXT + str);
          end
          else if Parser.CurrentCol = 1 then
          begin
            flag := 2;
            Val(str, y, err);
            if err <> 0 then
              raise EStrToFloutException.Create(ERR_CONV_LINE_TEXT + str);
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
    FreeAndNil(FileStream);
    FreeAndNil(Parser);
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
  xin, yin, xout, yout: double;
  tmplist: XYList;
begin
  err := 0;
  tmplist := InList;
  if (tmplist <> nil) and (nstep <> 0) then while tmplist^.index > nstep do tmplist := tmplist^.Next;
  while tmplist <> nil do
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
  formatx, formaty, precx, precy, digx, digy: integer;
  s: string;
  tmplist: XYList;
  x, y: extended;
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
  formatx := XCBox.ItemIndex;
  formaty := YCBox.ItemIndex;
  precx := PrecXSEdt.Value;
  precy := PrecYSEdt.Value;
  digx := DigXSEdt.Value;
  digy := DigYSEdt.Value;
  Builder := TCSVBuilder.Create;
  if mstream = nil then
    FileStream := TFileStream.Create(filename, fmCreate + fmOpenWrite +
      fmShareDenyWrite);
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
        s := FormatVal(x, formatx, precx, digx);
        Builder.AppendCell(s);
        s := FormatVal(y, formaty, precy, digy);
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
    FreeAndNil(Builder);
    if mstream = nil then
      FreeAndNil(FileStream);
  end;
end;

function TConvertForm.FormatVal(val: extended; format, prec, dig: integer): string;
var
  s: string;
begin
  case format of
    0: s := FloatToStrF(val, ffGeneral, prec, dig);
    1: s := FloatToStrF(val, ffFixed, prec, dig);
    2: s := FloatToStrF(val, ffExponent, prec, dig);
  end;
  Result := s;
end;

end.
