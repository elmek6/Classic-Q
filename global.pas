unit GLOBAL;


interface

const
  DUVAR  =  -1;
  BOS    =   0;
  MTOP   =  10;
  STOP   =  20;
  YTOP   =  30;
  KTOP   =  40;
  PTOP   =  50;
  FTOP   =  60;
  MDELIK = 110;
  SDELIK = 120;
  YDELIK = 130;
  KDELIK = 140;
  PDELIK = 150;
  FDELIK = 160;

var
  Matris :array[1..16]of array[1..16]of integer;

  SahaUzunX,
  SahaUzunY,
  TopSay    :integer;
  Takipci   :boolean;
  TakipciX,
  TakipciY  :integer; {x y}



implementation

procedure Goster;
begin
end;

end.
