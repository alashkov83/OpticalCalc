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

unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  {$IFDEF WINDOWS}
  Windows,
  {$ENDIF}
  Classes,
  SysUtils,
  Forms,
  Dialogs,
  Menus,
  StdCtrls,
  Math,
  Unit2,
  Unit4,
  Controls,
  LCLtype;

type

  { TMainForm }

  TMainForm = class(TForm)
    Label18: TLabel;
    step_calcBut: TButton;
    startTEd: TEdit;
    stopTEd: TEdit;
    stepTEd: TEdit;
    lambda_max2TEd: TEdit;
    cmTEd: TEdit;
    AbsTEd: TEdit;
    TTEd: TEdit;
    num_stepTEd: TEdit;
    ev_to_nmBut: TButton;
    cm_to_nmBut: TButton;
    D_to_TBut: TButton;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    convertMI: TMenuItem;
    nm_to_ev_cmBut: TButton;
    lambda_KPBut: TButton;
    lambdaTEd: TEdit;
    evTEd: TEdit;
    lambda_exTEd: TEdit;
    lambda_max1TEd: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    aboutMI: TMenuItem;
    exitMI: TMenuItem;
    OpnFileDlg: TOpenDialog;
    T_to_DBut: TButton;
    procedure cm_to_nmButClick(Sender: TObject);
    procedure D_to_TButClick(Sender: TObject);
    procedure lambdaTEdKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure evTEdKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure lambda_exTEdKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure cmTEdKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure AbsTEdKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure stepTEdKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure TTEdKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure ev_to_nmButClick(Sender: TObject);
    procedure convertMIClick(Sender: TObject);
    procedure nm_to_ev_cmButClick(Sender: TObject);
    procedure lambda_KPButClick(Sender: TObject);
    procedure aboutMIClick(Sender: TObject);
    procedure exitMIClick(Sender: TObject);
    procedure step_calcButClick(Sender: TObject);
    procedure TEditOnChange(Sender: TObject);
    procedure T_to_DButClick(Sender: TObject);
  private
    function calc_lambda_nu(lambda: extended; nu: extended): extended;
  public

  end;

const
  hc = 1239.841984;
  nu_1 = 3450.0;
  nu_2 = 1645.0;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

procedure TMainForm.ev_to_nmButClick(Sender: TObject);
var
  ev: extended;
  err: integer;
  s: string;

begin
  if (evTEd.Text <> '') then
    Val(evTEd.Text, ev, err)
  else
  begin
    ShowError('Не введено значение!');
    exit;
  end;
  if err = 0 then
  begin
    if ev > 0.0 then
    begin
      Str((hc / ev): 0: 2, s);
      lambdaTEd.Text := s;
    end
    else
      ShowWarning('Введите число > 0!');
  end
  else
    ShowError('Введите число! Ошибка: ' + evTEd.Text[err]);
end;

procedure TMainForm.convertMIClick(Sender: TObject);
var
  Form: TForm;

begin
  Form := Self.FindComponent('ConvertForm') as TForm;
  if Assigned(Form) then
  begin
    if Form.CanFocus then
      Form.SetFocus;
  end
  else
  begin
    //can't find it
    OpnFileDlg.InitialDir := GetCurrentDir;
    if OpnFileDlg.Execute then
      (TConvertForm.Create(Self, OpnFileDlg.Filename)).Show;
  end;
end;

procedure TMainForm.nm_to_ev_cmButClick(Sender: TObject);
var
  nm: extended;
  err: integer;
  s: string;

begin
  if (lambdaTEd.Text <> '') then
    Val(lambdaTEd.Text, nm, err)
  else
  begin
    ShowError('Не введено значение!');
    exit;
  end;
  if err = 0 then
  begin
    if nm > 0.0 then
    begin
      Str((hc / nm): 0: 4, s);
      evTEd.Text := s;
      Str((1E7 / nm): 0: 2, s);
      cmTEd.Text := s;
    end
    else
      ShowWarning('Введите число > 0!');
  end
  else
    ShowError('Введите число! Ошибка: ' + lambdaTEd.Text[err]);
end;


procedure TMainForm.cm_to_nmButClick(Sender: TObject);
var
  cm: extended;
  err: integer;
  s: string;

begin
  if (cmTEd.Text <> '') then
    Val(cmTEd.Text, cm, err)
  else
  begin
    ShowError('Не введено значение!');
    exit;
  end;
  if err = 0 then
  begin
    if cm > 0.0 then
    begin
      Str((1E7 / cm): 0: 2, s);
      lambdaTEd.Text := s;
    end
    else
      ShowWarning('Введите число > 0!');
  end
  else
    ShowError('Введите число! Ошибка: ' + cmTEd.Text[err]);
end;


procedure TMainForm.D_to_TButClick(Sender: TObject);
var
  D: extended;
  err: integer;
  s: string;

begin
  if (AbsTEd.Text <> '') then
    Val(AbsTEd.Text, D, err)
  else
  begin
    ShowError('Не введено значение!');
    exit;
  end;
  if err = 0 then
  begin
    if (D >= 0.0) and (D <= 10.0) then
    begin
      Str((100 * Power(10, -1.0 * D)): 0: 5, s);
      TTEd.Text := s;
    end
    else
      ShowWarning('Введите число в диапазоне 0-10!');
  end
  else
    ShowError('Введите число! Ошибка: ' + AbsTEd.Text[err]);
end;

procedure TMainForm.lambdaTEdKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    nm_to_ev_cmBut.Click;
end;

procedure TMainForm.evTEdKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    ev_to_nmBut.Click;
end;

procedure TMainForm.lambda_exTEdKeyDown(Sender: TObject; var Key: word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    lambda_KPBut.Click;
end;

procedure TMainForm.cmTEdKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    cm_to_nmBut.Click;
end;

procedure TMainForm.AbsTEdKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    D_to_TBut.Click;
end;

procedure TMainForm.stepTEdKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    step_calcBut.Click;
end;

procedure TMainForm.TTEdKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    T_to_DBut.Click;
end;

procedure TMainForm.lambda_KPButClick(Sender: TObject);
var
  lambda: extended;
  err: integer;
  s: string;

begin
  if (lambda_exTEd.Text <> '') then
    Val(lambda_exTEd.Text, lambda, err)
  else
  begin
    ShowError('Не введено значение!');
    exit;
  end;
  if err = 0 then
  begin
    if (lambda >= 190.0) and (lambda <= 2898.0) then
    begin
      Str((calc_lambda_nu(lambda, nu_1)): 0: 2, s);
      lambda_max1TEd.Text := s;
      Str((calc_lambda_nu(lambda, nu_2)): 0: 2, s);
      lambda_max2TEd.Text := s;
    end
    else
      ShowWarning('Введите число в диапазоне 190-2898!');
  end
  else
    ShowError('Введите число! Ошибка: ' + lambda_exTEd.Text[err]);
end;

procedure TMainForm.aboutMIClick(Sender: TObject);
begin
  ShowAbout;
end;

procedure TMainForm.exitMIClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.step_calcButClick(Sender: TObject);
var
  err1, err2, err3: integer;
  start, stop, step: extended;
  s: string;
begin
  if (startTEd.Text <> '') and (stopTEd.Text <> '') and (stepTEd.Text <> '') then
  begin
    Val(startTEd.Text, start, err1);
    Val(stopTEd.Text, stop, err2);
    Val(stepTEd.Text, step, err3);
  end
  else
  begin
    ShowError('Не введено одно или несколько значений!');
    exit;
  end;
  if (err1 = 0) and (err2 = 0) and (err3 = 0) then
  begin
    if step = 0.0 then
      ShowError('Шаг равен нулю')
    else
    begin
      Str(trunc(abs(stop - start) / step) + 1, s);
      num_stepTEd.Text := s;
    end;
  end
  else
  begin
    s := 'Неправильный ввод для:' + #10;
    if err1 <> 0 then
      s += 'Старт' + #10;
    if err2 <> 0 then
      s += 'Стоп' + #10;
    if err3 <> 0 then
      s += 'Шаг' + #10;
    ShowError(s);
  end;
end;

procedure TMainForm.TEditOnChange(Sender: TObject);
var
  edit: TEdit;
  s: string;
  posit: integer;
begin
  edit := Sender as TEdit;
  s := edit.Text;
  posit := pos('_', s);
  if posit <> 0 then
    s := StringReplace(s, '_', '.', [rfReplaceAll, rfIgnoreCase]);
  posit := pos(',', s);
  if posit <> 0 then
    s := StringReplace(s, ',', '.', [rfReplaceAll, rfIgnoreCase]);
  edit.Text := s;
end;

procedure TMainForm.T_to_DButClick(Sender: TObject);
var
  T: extended;
  D_tmp: extended;
  err: integer;
  s: string;
begin
  if (TTEd.Text <> '') then
    Val(TTEd.Text, T, err)
  else
  begin
    ShowError('Не введено значение!');
    exit;
  end;
  if err = 0 then
  begin
    if (T > 0.0) then
    begin
      D_tmp := -1.0 * Log10(T / 100);
      if D_tmp = -0.0 then
        Str(0.0: 0: 0, s)
      else
        Str(D_tmp: 0: 5, s);
      AbsTEd.Text := s;
    end
    else if (T = 0.0) then
    begin
      Str(99.0: 0: 5, s);
      AbsTEd.Text := s;
    end
    else
      ShowWarning('Введите число >= 0!');
  end
  else
    ShowError('Введите число! Ошибка: ' + TTEd.Text[err]);
end;

function TMainForm.calc_lambda_nu(lambda: extended; nu: extended): extended;
begin
  Result := 1 / (1 / lambda - (nu * 1E-07));
end;

end.
