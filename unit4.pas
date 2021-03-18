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

unit Unit4;

{$mode objfpc}{$H+}

interface

uses
  Forms,
  Classes,
  StdCtrls,
  LCLType;

var
  s_about: string = 'Optical Calc v. 2.1' + #10 +
    '©2020-2021 Лашков А., Набатов Б.' + #10 +
    'Для разработки использована среда Lazarus и Free Pascal Compiler version 3.0';

procedure ShowError(message: string);
procedure ShowWarning(message: string);
procedure ShowInfo(message: string);
procedure ShowAbout;
procedure LoadMemoFromMemoryStream(Memo : TMemo; Stream : TMemoryStream);

implementation

procedure ShowError(message: string);
begin
  Application.MessageBox(PChar(message), 'Ошибка!', MB_OK + MB_ICONERROR);
end;

procedure ShowWarning(message: string);
begin
  Application.MessageBox(PChar(message), 'Внимание!', MB_OK + MB_ICONWARNING);
end;

procedure ShowInfo(message: string);
begin
  Application.MessageBox(PChar(message), 'Информация',
    MB_OK + MB_ICONINFORMATION);
end;

procedure ShowAbout;
begin
  Application.MessageBox(PChar(s_about), 'О программе',
    MB_OK + MB_ICONINFORMATION);
end;

procedure LoadMemoFromMemoryStream(Memo : TMemo; Stream : TMemoryStream);
var
   p, q, r : PChar;
begin
   p := Stream.Memory;
   q := p + Stream.Size;// -1; fixed by Shay Horovitz
   r := p;
   while (p <> nil) and (p < q) do begin
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
