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

program OpticalCalc;

{$mode objfpc}{$H+}

uses {$IFDEF UNIX} {$IFDEF UseCThreads}
  cthreads, {$ENDIF} {$ENDIF}
  Forms,
  Interfaces,
  SysUtils,
  MainUnit,
  StringsUnit;

{$R *.res}

begin
  DefaultFormatSettings.DecimalSeparator := '.';
  RequireDerivedFormResource := True;
  Application.Scaled := True;
  Application.Title := APP_NAME_TEXT;
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.


