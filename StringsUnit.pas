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

unit StringsUnit;

{$mode objfpc}{$H+}

interface

var
   APP_NAME_TEXT: string;
   NO_ENTER_VALUE_TEXT: string;
   NO_ENTER_VALUES_TEXT: string;
   WARN_BELLOW_ZERO_TEXT: string;
   WARN_BELLOW_EQ_ZERO_TEXT: string;
   ENT_NUMBER_ERR_TEXT: string;
   ENT_NUMBER_IN_RANGE_TEXT: string;
   RANGE_1_10_TEXT: string;
   RANGE_190_2898_TEXT: string;
   ZERO_STEP_ERR_TEXT: string;
   INC_ENTER_FOR_TEXT: string;
   INC_DATA_TEXT: string;
   START_TEXT: string;
   STOP_TEXT: string;
   STEP_TEXT: string;
   ABOUT_TEXT: string;
   S_ABOUT_TEXT: string;
   ERR_TEXT: string;
   WARN_TEXT: string;
   INFO_TEXT: string;
   ERR_PARSING_TEXT: string;
   CONV_HELP_CAP_TEXT: string;
   CONV_SCHEMA_TEXT: string;
   FORMAT_HELP_TEXT: string;
   FORMAT_HELP_CAP_TEXT: string;
   EMPTY_LIST_TEXT: string;
   SUCCESS_CONV_TEXT: string;
   WARN_CONV_TEXT: string;
   FILE_TEXT: string;
   SUC_SAVE_TEXT: string;
   PREVIEW_TEXT: string;
   ERR_CONV_LINE_TEXT: string;
   FMT_GEN_HINT_TEXT: string;
   FMT_FIX_HINT_TEXT: string;
   FMT_EXP_HINT_TEXT: string;
   PREC_FIX_HINT_TEXT: string;
   PREC_EXP_HINT_TEXT: string;
   DIG_FIX_HINT_TEXT: string;
   DIG_EXP_HINT_TEXT: string;

implementation

begin
APP_NAME_TEXT := 'Optical Calc v. 2.2';
NO_ENTER_VALUE_TEXT := 'Не введено значение!';
WARN_BELLOW_ZERO_TEXT := 'Введите число > 0!';
ENT_NUMBER_ERR_TEXT := 'Введите число! Ошибка: ';
ENT_NUMBER_IN_RANGE_TEXT := 'Введите число в диапазоне ';
RANGE_1_10_TEXT := '1-10!';
RANGE_190_2898_TEXT := '190-2898!';
NO_ENTER_VALUES_TEXT := 'Не введено одно или несколько значений!';
ZERO_STEP_ERR_TEXT := 'Шаг равен нулю!';
INC_DATA_TEXT := 'Неверные данные!';
INC_ENTER_FOR_TEXT := 'Неправильный ввод для:';
START_TEXT := 'Старт';
STOP_TEXT := 'Cтоп';
STEP_TEXT := 'Шаг';
WARN_BELLOW_EQ_ZERO_TEXT := 'Введите число >= 0!';
ABOUT_TEXT := 'О программе';
S_ABOUT_TEXT := APP_NAME_TEXT + #10 +
              '©2020-2021 Лашков А., Набатов Б.' + #10 +
              'Для разработки использована среда Lazarus и Free Pascal Compiler version 3.0';
ERR_TEXT := 'Ошибка!';
WARN_TEXT := 'Внимание!';
INFO_TEXT := 'Информация';
ERR_PARSING_TEXT := 'Ошибка разбора файла: ';
CONV_HELP_CAP_TEXT := 'Операции конвертации';
CONV_SCHEMA_TEXT := '                  /-> F(R)' + #10 +
                    'Abs <-> %T = %R <-' + #10 +
                    '                  \-> Absolute_%R';
FORMAT_HELP_TEXT := 'Общий - форматирует число в соответствии с фиксированной или экспоненциальной нотацией:' + #10 +
                    'по возможности применяется фиксированная нотация. Ведущие нули удаляются,' + #10 +
                    'и если перед десятичной точкой нет цифр, символ разделителя также удаляется.' + #10 +
                    'Формат экспоненты используется, если мантисса числа является слишком большой' + #10 +
                    'для указанного параметра "Точность" или число < 0.00001. В этом случае, параметр "Разряды"' + #10 +
                    'определяет минимальное количество цифр порядка.' + #10 +
                    #10 +
                    'Фиксированный - число форматируется в соответствии с фиксированной десятичной нотацией.' + #10 +
                    'Как минимум одна цифра всегда присутствует перед десятичным разделителем.' + #10 +
                    'Отображает кол-во цифр перед десятичной точкой, задаётся параметром "Точность",' + #10 +
                    'а после точки - параметром "Разряды". Если слева от десятичного разделителя требуется' + #10 +
                    'более чем "Точность" цифр, формат автоматически меняется на экспоненциальный.' + #10 +
                    #10 +
                    'Экспонента - форматирует число в соответствии с научной нотацией.' + #10 +
                    'Всегда присутствует минимум одна цифра перед десятичным разделителем,' + #10 +
                    'параметр "Точность" определяет общее число форматируемых цифр мантиссы.' + #10 +
                    'Параметр "Разряды" определяет минимальное количество цифр порядка (1-4).' + #10 +
                    'Экспонента всегда начинается со знака "плюс" или "минус".';
FORMAT_HELP_CAP_TEXT := 'Формат чисел';
EMPTY_LIST_TEXT := 'Cписок входных данных пуст!';
SUCCESS_CONV_TEXT := 'Преобразование прошло успешно!';
WARN_CONV_TEXT := 'Выход значения за границы допустимого диапазона !' + #13 +
                  'Сделана принудительная корректировка';
FILE_TEXT := 'Файл';
SUC_SAVE_TEXT := 'успешно сохранён!';
PREVIEW_TEXT := 'Предварительный просмотр';
ERR_CONV_LINE_TEXT := 'Ошибка преобразования строки:';
FMT_GEN_HINT_TEXT := 'Число в фиксированном или экспоненциальном формате';
FMT_FIX_HINT_TEXT := 'Фиксированная десятичная нотация ((-)xxx.xxx)';
FMT_EXP_HINT_TEXT :=  'Научная (экспоненциальная) нотация ((-)x.xxxE(+|-)x)';
PREC_FIX_HINT_TEXT := 'Число цифр перед десятичной точкой';
PREC_EXP_HINT_TEXT := 'Число цифр мантиссы';
DIG_FIX_HINT_TEXT :=  'Число цифр после десятичной точки';
DIG_EXP_HINT_TEXT := 'Минимальное число цифр порядка';
end.

