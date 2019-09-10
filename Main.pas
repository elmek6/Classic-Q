unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, IniFiles, CheckLst;

type
  TForm1 = class(TForm)
    imgBos: TImage;
    BitBtn1: TBitBtn;
    imgDuvar: TImage;
    imgDelikM: TImage;
    imgDelikS: TImage;
    imgDelikY: TImage;
    imdDelikK: TImage;
    imdTopM: TImage;
    imgTopS: TImage;
    imgTopY: TImage;
    imgTopK: TImage;
    chlBolum: TCheckListBox;
    cmd2: TSpeedButton;
    cmd4: TSpeedButton;
    cmd5: TSpeedButton;
    cmd6: TSpeedButton;
    cmd8: TSpeedButton;
    tmrZaman: TTimer;
    Panel1: TPanel;
    imgMain: TImage;
    shpTakipci: TShape;
    procedure BitBtn1Click(Sender: TObject);
    procedure chlBolumDblClick(Sender: TObject);
    procedure cmdHareket(Sender: TObject);
    procedure tmrZamanTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    procedure SahaDose(bolum :string);
    procedure SahaCiz;
    procedure Bitim;
    procedure HareketEt(yon: integer);
  published
    { Public declarations }
  end;

var
  Form1: TForm1;


implementation

uses global;

{$R *.dfm}

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  SahaUzunX := 10;
  SahaUzunY := 10;
  TopSay    := 2;

//  imgMain.Canvas.BrushCopy(Rect(0,0,10,10), alan.Canvas, Rect(0,0,15,15));

//  alan.Canvas.MoveTo();

{
  ACanvas.Pen.Color := FFSeparatorColor;
    ACanvas.MoveTo(X1,
      TextRect.Top +
      Round((TextRect.Bottom - TextRect.Top) / 2));
    ACanvas.LineTo(X2,
      TextRect.Top +
      Round((TextRect.Bottom - TextRect.Top) / 2))
  {
  (0, 0, B.Width, B.Height),
 FMenuItem.Bitmap.Canvas,
 Rect(0, 0, B.Width, B.Height));
  imgMain.Picture.Graphic.
  }
end;

procedure TForm1.SahaCiz;
  var
    x,y     :integer;
    alan    :TBitMap;
    top     :integer;
begin
  alan := TBitmap.Create;
  imgMain.Picture.Bitmap.Width := SahaUzunX*20;
  imgMain.Picture.Bitmap.Height := SahaUzunY*20;

  top := 0;

  for x:=1 to SahaUzunX do begin
    for y:=1 to SahaUzunY do begin
      case Matris[x][y] of
        DUVAR  : alan.LoadFromFile('wand.bmp');
        BOS    : alan.LoadFromFile('frei.bmp');
        MTOP   : alan.LoadFromFile('top_blau.bmp');
        STOP   : alan.LoadFromFile('top_gelb.bmp');
        YTOP   : alan.LoadFromFile('top_grün.bmp');
        KTOP   : alan.LoadFromFile('top_rot.bmp');
        PTOP   : alan.LoadFromFile('top_p.bmp');
        FTOP   : alan.LoadFromFile('top_f.bmp');
        MDELIK : alan.LoadFromFile('delik_blau.bmp');
        SDELIK : alan.LoadFromFile('delik_gelb.bmp');
        YDELIK : alan.LoadFromFile('delik_grün.bmp');
        KDELIK : alan.LoadFromFile('delik_rot.bmp');
        PDELIK : alan.LoadFromFile('delik_p.bmp');
        FDELIK : alan.LoadFromFile('delik_f.bmp');
      end;
      if Matris[x][y] in [MTOP,STOP,YTOP,KTOP,PTOP,FTOP] then
        inc(top);
      imgMain.Canvas.Draw((x-1)*20,(y-1)*20, alan);
    end;
  end;

  if top=0 then
    showmessage('Tebrik');
end;

procedure TForm1.SahaDose(bolum :string);
  var
    i,
    x, y    :integer;
    dosya   :TiniFile;
    s       :TStrings;
    yol     :string;

begin
  yol := application.ExeName;
  while yol[Length(yol)]<>'\' do delete(yol,length(yol),1);

  s := TStringList.Create;

  dosya := TIniFile.Create(yol+'oyun.ini');

  try
    {GENEL}

    SahaUzunY := dosya.ReadInteger(Bolum, 'SahaUzunY', 0);
    SahaUzunX := dosya.ReadInteger(Bolum, 'SahaUzunX', 0);

    for i:=1 to SahaUzunY do
      s.Add(dosya.ReadString(Bolum, inttostr(i), ''));
  finally
    dosya.free;
  end;


  for x:=1 to SahaUzunX do begin
    for y:=1 to SahaUzunY do begin
      case s.Strings[y-1][x] of
        '#': Matris[x][y] := DUVAR;
    ' ','-': Matris[x][y] := BOS;
        'm': Matris[x][y] := MTOP;
        's': Matris[x][y] := STOP;
        'y': Matris[x][y] := YTOP;
        'k': Matris[x][y] := KTOP;
        'p': Matris[x][y] := PTOP;
        'f': Matris[x][y] := FTOP;
        'M': Matris[x][y] := MDELIK;
        'S': Matris[x][y] := SDELIK;
        'Y': Matris[x][y] := YDELIK;
        'K': Matris[x][y] := KDELIK;
        'P': Matris[x][y] := PDELIK;
        'F': Matris[x][y] := FDELIK;
      end;
    end;
  end;

  sahaCiz;
end;

procedure TForm1.chlBolumDblClick(Sender: TObject);
begin
  SahaDose(chlBolum.Items[chlBolum.ItemIndex]);
end;

procedure TForm1.cmdHareket(Sender: TObject);
begin
  HareketEt((sender as TSpeedButton).Tag);
end;

procedure TForm1.Bitim;
  var
    x,  y :integer;
    r     :boolean;
begin
  r := True;
  for x := 1 to SahaUzunX do
    for y := 1 to SahaUzunY do
      case Matris[x][y] of
        MTOP,
        STOP,
        YTOP,
        KTOP,
        PTOP,
        FTOP: r := false;
      end;

  if r then
    showmessagefmt('Tebrikler. Bu oyunda %d hamle yaptiniz ve oyun %d saniye sürdü...', [0, tmrZaman.tag]);
end;

procedure TForm1.tmrZamanTimer(Sender: TObject);
begin
  tmrZaman.Tag := tmrZaman.Tag + 1;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  TakipciX := 1;
  TakipciY := 1;
end;

procedure TForm1.HareketEt(yon: integer);
var
  i     :integer;

  carpmaX,
  carpmaY,
  engelX,
  engelY,
  son    :integer;
begin
  if yon=5 then Takipci := not Takipci;

  if Takipci  then begin

    { Takipci top olmayan bir yeri tutmaya calisti }
    if not(matris[TakipciX][TakipciY] in [MTOP,STOP,YTOP,KTOP,PTOP,FTOP]) then begin
      Takipci := False;
      exit;
    end;

    i := 0;
    son := 0;
    case yon of
      2:begin { Yukari, Up, Oben }
          while Matris[TakipciX][TakipciY-i-1]=BOS do
            inc(i);
          engelX := TakipciX;
          engelY := TakipciY-i-1;
          carpmaX := TakipciX;
          carpmaY := TakipciY-i;
        end;
      4:begin { Sola, Left, Link }
          while Matris[TakipciX-i-1][TakipciY]=BOS do
            inc(i);
          engelX := TakipciX-i-1;
          engelY := TakipciY;
          carpmaX := TakipciX-i;
          carpmaY := TakipciY;
        end;
      6:begin { Saga, Right, Recht }
          while Matris[TakipciX+i+1][TakipciY]=BOS do
            inc(i);
          engelX := TakipciX+i+1;
          engelY := TakipciY;
          carpmaX := TakipciX+i;
          carpmaY := TakipciY;
        end;
      8:begin { Assagi, Down, Unter }
          while Matris[TakipciX][TakipciY+i+1]=BOS do
            inc(i);
          engelX := TakipciX;
          engelY := TakipciY+i+1;
          carpmaX := TakipciX;
          carpmaY := TakipciY+i;
        end;
      else
        exit;
    end;

    if Matris[TakipciX][TakipciY]+100<>Matris[engelX][engelY] then
      Matris[carpmaX][carpmaY] := Matris[TakipciX][TakipciY]
    else i := 1;

    if i<>0 then Matris[TakipciX][TakipciY] := BOS;

    TakipciX := CarpmaX;
    TakipciY := CarpmaY;
    shpTakipci.Top  := (TakipciY-1)*20;
    shpTakipci.Left := (TakipciX-1)*20;

    SahaCiz;

  end else begin
  { Takipci Oynatiliyor }

    case yon of
      2:if TakipciY>1 then dec(TakipciY);
      4:if TakipciX>1 then dec(TakipciX);
      6:if TakipciX<16 then inc(TakipciX);
      8:if TakipciY<16 then inc(TakipciY);
    end;

    shpTakipci.Top  := (TakipciY-1)*20;
    shpTakipci.Left := (TakipciX-1)*20;
  end;
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case upcase(key) of
    'W':HareketEt(2);
    'A':HareketEt(4);
    'S':HareketEt(5);
    'D':HareketEt(6);
    'X':HareketEt(8);
  end;
end;

end.
