unit ConstUnit;

{$mode objfpc}{$H+}

interface

const
  hc: extended = 1239.841984;
  nu_1: real = 3450.0;
  nu_2: real = 1645.0;
  xmes: array[1..4] of string =
    ('Wavelength (nm)', 'Wavenumber (cm-1)', 'Energy (eV)', 'Time (min)');
  ymes: array[1..5] of string = ('%T', 'Abs', '%R', 'F(R)', 'Absolute %R');

implementation

end.
