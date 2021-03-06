unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
   StdCtrls, ExtCtrls, Buttons, sSkinManager, sButton, sPanel,
  jpeg,dialogs, sLabel, sEdit, sSpinEdit, sSkinProvider,  sCheckBox,
  GlEngine;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    sSkinManager1: TsSkinManager;
    sButton1: TsButton;
    sPanel1: TsPanel;
    sButton2: TsButton;
    Image1: TImage;
    Level: TsSpinEdit;
    sLabelFX1: TsLabelFX;
    sLabelFX2: TsLabelFX;
    HardEdit: TsSpinEdit;
    sSkinProvider1: TsSkinProvider;
    ShowCaption: TsCheckBox;
    Panel1: TPanel;
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sButton2Click(Sender: TObject);
    procedure HardEditChange(Sender: TObject);
    procedure GLSceneViewer1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Panel1Click(Sender: TObject);
    procedure Panel1Resize(Sender: TObject);
  private
    { Private declarations }
  public
   Procedure LevelStart;
    { Public declarations }
  end;

 TTypeArmor =  (aSoldir,aSniper,aMedik);
 TTypeMonstr = (mZombi,mEgg,mQueen,mGrom);
 TTypeWeapon = (wPistol);
 TTypeBullet = (bBullet,bRocket,bFire,bBoomBullet);

// TTerrainTypes = (ttNormal,ttSand,ttForest,ttRoad,ttObstacle);

{ TMap=class

 end; }

 TArmor = class;

 TboomPart=record
   x,y,dx,dy,r:real;
  end;

 TWeapon=class
  TypeBullet:TTypeBullet;
   angle:single;
   Speed:real;
   x,y,dx,dy:single;
   damage:integer;
   Distance,MaxDistance:integer;
   Im:Cardinal;
   Parent:TArmor;
   Procedure Add(ParentArmor:TArmor;x,y,dx,dy:single);Virtual; Abstract;
   procedure move;Virtual; Abstract;
   Procedure draw;Virtual; Abstract;
   Procedure kill;
  end;

 TBullet = class(TWeapon)
   Procedure Add(ParentArmor:TArmor;x,y,dx,dy:single); Override;
   procedure move;  Override;
   Procedure draw;  Override;
//   Procedure kill; Override;
  end;

 TFire = class(TWeapon)
   Procedure Add(ParentArmor:TArmor;x,y,dx,dy:single); Override;
   procedure move;  Override;
   Procedure draw;  Override;
 //  Procedure kill; Override;
  end;

 TBoomBullet = class(TWeapon)
   size: single;
   Procedure Add(ParentArmor:TArmor;x,y,dx,dy,size:single);
   procedure move;  Override;
   Procedure draw;  Override;
 //  Procedure kill; Override;
  end;

 {TWeapon = class
   TypeWeapon:TTypeWeapon;
   Time, TimeShoot: integer;
  private
    procedure kill;

  end; }

 Tboom=class
  Parts:array[0..30] of TboomPart;
  step:integer;
  xn,yn:real;
  AllStep:integer;
  Color:TGLColor;
  Angle:integer;
  aminBoom:TGLAnim;
  procedure Add(x,y:integer;c:TGLColor);
  procedure Draw(gle : TGLEngine);
 end;

 TMonstr = class(Tobject)
   TypeMonstr:TTypeMonstr;
   target:Tarmor;
   distance:single;
   ColorZombi:TGLColor;
   x,y:real;
   dx,dy:single;
   healt:integer;
   speed:real;
   Function  GetNearArmor(Var distance:single):Tarmor;
   Procedure FindTarget; Virtual; Abstract;
   Procedure Life; Virtual; Abstract;
   Procedure Move; Virtual; Abstract;
   Procedure Attak; Virtual; Abstract;
   Procedure Deat; Virtual; Abstract;
   Procedure Draw(gle : TGLEngine);  Virtual; Abstract;
   Function GetPosition:TPoint; Virtual; Abstract;
  end;

  TZombi = class(TMonstr)
   Procedure FindTarget;  Override;
   Procedure Life; Override;
   Procedure Move; Override;
   Procedure Attak; Override;
   Procedure Deat;  Override;
   Procedure Draw(gle : TGLEngine); Override;
   Function GetPosition:TPoint; Override;
  end;

  TQueen = class(TMonstr)
   TimeForLife:integer;
   TimeLife:integer;
   Procedure FindTarget;  Override;
   Procedure Life; Override;
   Procedure Move; Override;
   Procedure Attak; Override;
   Procedure Deat;  Override;
   Procedure Draw(gle : TGLEngine); Override;
   Function GetPosition:TPoint; Override;
  end;

  TGrom = class(TMonstr)
  CountShoot:Integer;
   Procedure FindTarget;  Override;
   Procedure Life; Override;
   Procedure Move; Override;
   Procedure Attak; Override;
   Procedure Deat;  Override;
   Procedure Draw(gle : TGLEngine); Override;
   Function GetPosition:TPoint; Override;
  end;

  TArmor = class
   TypeArmor:TTypeArmor;
   Weapon:TTypeBullet;
   x,y:real;
   healt:real;
   LaserColor:TGLColor;
   Distance,DistanceDanger:single;
   target: TMonstr;
   dangerZombi: TMonstr;
   DistanseAtack:real;
   Uron:Real;
   speed:real;
   SpeedAtack:Integer;
   Rang:single;
    Function  GetNearMonstr(Var distance:single):TMonstr;
    Procedure Attak;
    Procedure Life;  Virtual; Abstract;
    Procedure FindTarget; Virtual; Abstract;
    Procedure Faer; Virtual; Abstract;
    Procedure draw(gle : TGLEngine); Virtual; Abstract;
    Procedure Move;  Virtual; Abstract;
    Procedure Deat; Virtual; Abstract;
 end;

 TSoldir= class(Tarmor)
    sdvig,delta:single;
    amin:TGLAnim;
    Procedure Life; Override;
    Procedure FindTarget; Override;
    Procedure Faer; Override;
    Procedure draw(gle : TGLEngine); Override;
    Procedure Move; Override;
    Procedure Deat; Override;
 end;

 TMedik= class(Tarmor)
   TargetAr:TArmor;
    Procedure Life; Override;
    Procedure FindTarget; Override;
    Procedure Faer; Override;
    Procedure draw(gle : TGLEngine); Override;
    Procedure Move; Override;
    Procedure Deat; Override;
 end;

  TSniper = class(Tarmor)
   CountShoot:Integer;
    Procedure Life; Override;
    Procedure FindTarget; Override;
    Procedure Faer; Override;
    Procedure draw(gle : TGLEngine); Override;
    Procedure Move; Override;
    Procedure Deat; Override;
 end;

var
  kzombi:integer=1;
  karmor:integer=1;
  hard:integer=4;
  Form1: TForm1;
  m:TList;
  a:TList;
  booms:Tlist;
  Bullets:Tlist;
  GLE:TGLEngine=nil;
  Im:Cardinal;
  Imb:Cardinal;

  ImZombi:cardinal;
  ImFire:cardinal;
  ImQueen:Cardinal;
  ImSoldir:Cardinal;
  ImGrom:Cardinal;
  ImSniper:Cardinal;
  ImMedik:Cardinal;
  ImBlood:Cardinal;
  ImBoomParts:array[1..24] of Cardinal;
  ImTank:Cardinal;

  Ani:TGLAnim;
  AnSoldir:TGLAnim;
implementation
  uses unit3;
{$R *.dfm}

procedure NormalVector(var dx, dy:Single; speed: Single);
var
 k,d:real;
begin
 d:=sqrt(dx*dx+dy*dy);
 k:=3/d;
 dx:=dx*k*{(0.8-random)*}Speed*0.4+(0.5-random)*2;
 dy:=dy*k*{(0.8-random)*}Speed*0.4+(0.5-random)*2;
end;

Function CalcAngle(Dx,Dy:single):single;
begin
 result:=arctan(dy/dx)*(180/3.14);
 if dx>0 then
  result:=result+90
 else
  result:=result-90;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 Image1.Visible:=false;
 randomize;
 karmor:=Level.Value;
 kzombi:=(Level.Value-1)*hard+1;
 Panel1.Visible:=true;
 LevelStart;
 Timer1.Enabled:=true;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
 var
   i : Integer;
    Zombi:TZombi;
    Soldir:TSoldir;
    Sniper:TSniper;
    Medik:TMedik;
    Queen:TQueen;
    Grom:TGrom;
    Bu:TBullet;
    Bbu:TBoomBullet;
    fire:TFire;
begin
{ TODO : ������� ���� }

//for i:=0 to a.Count-1 do

GLE.BeginRender(true);
GLE.AntiAlias(true);
gle.SetColor(1,1,1,1);


gle.SetColor(1,1,1,1);
 Gle.DrawImage(0,0,panel1.ClientWidth,Panel1.ClientHeight,0,false,false,Im);

i:=0;
try
While i<Bullets.Count do
begin
 case TWeapon(Bullets.Items[i]).TypeBullet of
  bBullet:
         begin
          Bu:= Tbullet(Bullets.Items[i]);
          bu.draw;
          bu.move;
         end;
  bFire:
        begin
          fire:=TFire(Bullets.Items[i]);
          fire.draw;
          fire.move;
        end;
  bBoomBullet:
        begin
          //Bbu:TBoomBullet;
          Bbu:=TBoomBullet(Bullets.Items[i]);
          Bbu.draw;
          Bbu.move;
        end;
 end ;
 i:=i+1;
end;
except
// showMessage('Bullets');
end;

i:=0;
try
While i<a.Count do
 begin
 Case TArmor(a.Items[i]).TypeArmor of
 aSoldir:
     begin
         Soldir:=TSoldir(a.Items[i]);
         Soldir.FindTarget;
         if i<>0 then
          Soldir.Move;
         Soldir.draw(Gle);
         Soldir.Faer;

     end;
 aSniper:
     begin
         Sniper:=TSniper(a.Items[i]);
         Sniper.FindTarget;
         if i<>0 then
          Sniper.Move;
         Sniper.draw(Gle);
         Sniper.Faer;

     end;
  aMedik:
     begin
         Medik:=TMedik(a.Items[i]);
         Medik.FindTarget;
         if i<>0 then
          Medik.Move;
         Medik.draw(Gle);
         Medik.Faer;

     end;
 end;
 i:=i+1;
end;
except
 showMessage('armor');
end;
//for i:=0 to kzombi do

try
i:=0;
While i<m.Count do
begin
case TMonstr(m.Items[i]).TypeMonstr of
 mZombi:
  begin
   Zombi:=TZombi(m.Items[i]);
   Zombi.FindTarget;
   Zombi.Move;
   Zombi.Draw(Gle);
   Zombi.Attak;
   i:=i+1;
  end;
 mQueen:
  begin
   Queen:=TQueen(m.Items[i]);
   Queen.FindTarget;
   Queen.Move;
   Queen.Draw(Gle);
   Queen.Attak;
   i:=i+1;
  end;
 mGrom:
  begin
   Grom:=TGrom(m.Items[i]);
   Grom.FindTarget;
   Grom.Move;
   Grom.Draw(Gle);
   Grom.Attak;
   i:=i+1;
  end;
 end;
end;
except
 showMessage('Monstr');
end;

try
i:=0;
While i<Booms.Count do
begin
 Tboom(Booms.Items[i]).Draw(Gle);
 i:=i+1;
end;
except
 showMessage('Booms');
end;



 Gle.SetColor(1,1,1,0.5);
 Gle.TextOut(4,20,'���������� - '+Inttostr(a.Count));
 Gle.TextOut(4,40,'�������� - '+Inttostr(m.Count));
 Gle.TextOut(4,60,'FPS - '+Inttostr(GLE.GetFPS));
// Form1.GLWindowsBitmapFont1.TextOut(rci, 4, 20, '���������� - '+Inttostr(a.Count)+#13+'�������� - '+Inttostr(m.Count), clWhite);

GLE.FinishRender;
//glc.Free;
 if (m.Count<=1)and(Booms.Count=0) then
 begin
  timer1.Enabled:=false;
  Image1.Visible:=true;
  Panel1.Visible:=false;
  form3.ShowModal;
//  Delay(10);
  Image1.Visible:=false;
  Panel1.Visible:=true;
//  Showmessage('Next Level!');
//  form1.Show;
  timer1.Enabled:=true;
  LevelStart;
 end;
end;

{ TZombi }

procedure TZombi.Attak;
var
 Queen:TQueen;
begin
 If distance<50 then
begin
 Gle.SetColor(0,0.5,0.5,1);

 If target<>nil then
 begin
  GLE.Line(x,y,target.x,target.y);
  target.healt:=target.healt-1;
  if target.healt<=0 then
  begin
   healt:=healt+500;
   If healt>1000 then
   begin
    Queen:=TQueen.Create;
    Queen.Life;
    Queen.x:=x;
    Queen.y:=y;
    m.Add(Queen);
    deat;
   end;
   target.Deat;
   Target:=nil;
 //  Pointer(Target):=nil;
  end;
 end;
end
end;

procedure TZombi.Life;
begin
 TypeMonstr:=mZombi;
 x:=(Form1.Width/2)-100+random(200);
 ColorZombi.Red:=0;
 ColorZombi.Green:=(100+random(150))/255;
 ColorZombi.Blue:=(100+random(150))/255;
 ColorZombi.alpha:=0.7;
 y:=6;
 healt:=random(500);
 speed:=2+random/2;
 dx:=3-random(6);
 dy:=3-random(6);
 FindTarget
end;

procedure TZombi.Deat;
var
  boom:Tboom;
begin
 m.Remove(self);
 boom:=Tboom.Create;
 boom.Add(Round(x),round(y),GLE.ColorGL(1,1,1,0.5));
 Booms.Add(boom);

 // ����� �� �����
 Gle.BeginRenderToTex(Im,1024,601);
//  gle.SetColor(1,1,1,0.005);
//  gle.DrawImage(0,0,form1.Panel1.ClientWidth,form1.Panel1.ClientHeight,0,false,imb);
  gle.SetColor(1,0,0,0.8);
  gle.DrawImage(x,y,40+random(20),40+random(20),Random(360),true,false,ImBlood);
 gle.EndRenderToTex;

 Free;
end;

procedure TZombi.Draw(gle : TGLEngine);
var
 angle:single;
begin
 GLE.SetColor(ColorZombi);
// GLE.Ellipse(x,y,healt/20,healt/20,0,40);

 angle:=0;
 If target<>nil then
  angle:=CalcAngle(target.x-x,Target.y-y);

 GLe.DrawImage(x,y,10+healt/20,10+healt/20,angle,true,false,ImZombi);
 if Form1.ShowCaption.Checked then
begin
 Gle.SetColor(1,1,1,0.5);
 Gle.TextOut(x+4,y,Inttostr(Round(healt))+ '%');
end;
end;

procedure TZombi.FindTarget;
begin
//if target=nil then
 target:=GetNearArmor(Distance);
If target<>nil then
 begin
  dx:=target.x-x;
  dy:=target.y-y;
  NormalVector(dx,dy,speed);
 end;
end;

function TZombi.GetPosition: TPoint;
begin
 result.X:=Round(x);
 result.Y:=Round(y);
end;

procedure TZombi.Move;
begin

 if healt<700 then
  healt:=healt+1;
 x:=x+dx;
 y:=y+dy;
end;

{ TArmor }

procedure TForm1.FormDestroy(Sender: TObject);
var
 i:integer;
begin
 timer1.Enabled:=false;
 for i:=0 to a.Count-1 do
  Tarmor(a.Items[i]).Free;
 for i:=0 to m.Count-1 do
  TZombi(m.Items[i]).Free;
 for i:=0 to booms.Count-1 do
  Tboom(booms.Items[i]).Free;
 for i:=0 to bullets.Count-1 do
  Tbullet(bullets.Items[i]).free;
 a.Free;
 m.Free;
 booms.Free;
 bullets.Free;
end;


procedure TForm1.FormCreate(Sender: TObject);
var
 i:integer;
begin
 a:=Tlist.Create;
 m:=Tlist.Create;
 booms:=Tlist.Create;
 Bullets:=Tlist.Create;
 GLE:=TGLEngine.Create;
 GLE.VisualInit(GetDC(Panel1.Handle),Panel1.ClientWidth,Panel1.ClientHeight,2);
 GLE.LoadImage(ExtractFilePath(Application.ExeName)+'Ground.jpg',Im,false);
 GLE.LoadImage(ExtractFilePath(Application.ExeName)+'Ground.jpg',Imb,false);
 GLE.LoadImage(ExtractFilePath(Application.ExeName)+'Image\Zombi.tga',ImZombi,false);
 GLE.LoadImage(ExtractFilePath(Application.ExeName)+'Image\Queen.tga',ImQueen,false);
// GLE.LoadImage(ExtractFilePath(Application.ExeName)+'Image\Soldir.tga',ImSoldir,false);
 GLE.LoadImage(ExtractFilePath(Application.ExeName)+'Image\Grom.tga',ImGrom,false);
 GLE.LoadImage(ExtractFilePath(Application.ExeName)+'Image\Sniper.tga',ImSniper,false);
 GLE.LoadImage(ExtractFilePath(Application.ExeName)+'Image\Medik.tga',ImMedik,false);
 GLE.LoadImage(ExtractFilePath(Application.ExeName)+'Image\p.tga',ImFire,false);
 GLE.LoadImage(ExtractFilePath(Application.ExeName)+'Image\blood.png',ImBlood,false);

 GLE.LoadImage(ExtractFilePath(Application.ExeName)+'Image\sniper.tga',ImTank,false);


 GLE.LoadAnimation(ExtractFilePath(Application.ExeName)+'Image\e.tga',256,256,64,64,ani,false);
 GLE.LoadAnimation(ExtractFilePath(Application.ExeName)+'Image\soldir_anim.png',25,135,25,27,AnSoldir ,false);
 for i:=1 to 24 do
  begin
   GLE.LoadImage(ExtractFilePath(Application.ExeName)+'Image\boom\'+inttostr(i)+'.png',ImBoomParts[i],false);
  end;

  Gle.BeginRenderToTex(Im,1024,601);
 //gle.DrawImage(0,0,1024,601,0,false,Imb);
// gle.SetColor(random,random,random,0.3);
   gle.SetColor(1,1,1,0.9);
   Gle.DrawImage(0,0,panel1.ClientWidth,Panel1.ClientHeight,0,false,false,Imb);
  gle.EndRenderToTex;
end;

{procedure Delay(ms: longint);
var
 TheTime: LongInt;
begin
 TheTime := GetTickCount + ms;
  while GetTickCount < TheTime do
   application.ProcessMessages;
end;}


procedure TForm1.sButton2Click(Sender: TObject);
begin
 close
end;

procedure TForm1.LevelStart;
var
 i:integer;
  Soldir:TSoldir;
  Sniper:TSniper;
 Zombi:Tzombi;
 medik:TMedik;
 Queen:TQueen;
 Grom:TGrom;
begin
 Level.Value:=karmor;
 karmor:=karmor+1;
 kzombi:=kzombi+hard;
 for i:=0 to bullets.Count-1 do
  TWeapon(bullets.Items[i]).free;
 for i:=0 to a.Count-1 do
  Tarmor(a.Items[i]).Free;
 for i:=0 to m.Count-1 do
  TZombi(m.Items[i]).Free;

 bullets.Clear;
 a.Clear;
 m.Clear;
 
for i:=0 to round(karmor*0.8) do
 begin
  Soldir:=TSoldir.Create;
  Soldir.Life;
  a.Add(Soldir)
 end ;

for i:=0 to round(karmor*0.3) do
 begin
  Sniper:=TSniper.Create;
  Sniper.Life;
  a.Add(Sniper)
 end ;

for i:=0 to round(karmor*0.2) do
 begin
  Medik:=TMedik.Create;
  Medik.Life;
  a.Add(Medik)
 end ;

{for i:=0 to round(kzombi) do
 begin
  Zombi:=Tzombi.Create;
  Zombi.Life;
  m.Add(Zombi);
 end;  }

for i:=0 to round(kzombi*0.5) do
 begin
  Queen:=TQueen.Create;
  Queen.Life;
  m.Add(Queen);
 end;

{ for i:=0 to round(kzombi*0.1) do
 begin
  Grom:=TGrom.Create;
  Grom.Life;
  m.Add(Grom);
 end;   }

end;

procedure TForm1.HardEditChange(Sender: TObject);
begin
 hard:=HardEdit.Value;
end;

{ TArmor }

procedure TArmor.Attak;
var
 bu:Tbullet;
 fire:Tfire;
 bbu:TBoomBullet;
begin
 case Weapon of
  bBullet:  begin
             bu:=TBullet.Create;
             bu.Add(self,x,y,target.x-x,target.y-y);
             bullets.add(bu);
            end;
  bFire:    Begin
             Fire:=Tfire.Create;
             Fire.Add(self,x,y,target.x-x,target.y-y);
             bullets.add(Fire);
            end;
  bBoomBullet : begin
             bbu:=TBoomBullet.Create;
             bbu.Add(self,x,y,target.x-x,target.y-y,170);
             bullets.add(bbu);
            end;
  end;
end;

function TArmor.GetNearMonstr(var distance: single): TMonstr;
var
 i:integer;
 min:single;
 Zombi:TZombi;
begin
 result:=nil;
 min:=50000;

 i:=0;
 While i<m.Count do
 begin
 Zombi:=TZombi(m.Items[i]);
 if SQRT(sqr(Zombi.x-x)+sqr(Zombi.y-y))<min then
 begin
  min:=SQRT(sqr(Zombi.x-x)+sqr(Zombi.y-y));
  result:=Zombi;
 end;
  i:=i+1;
 end;
 distance:=min;
end;

{ TSniper }

procedure TSniper.Deat;
var
  boom:Tboom;
begin
 a.Remove(self);
 boom:=Tboom.Create;
 boom.Add(Round(x),round(y),GLE.ColorGL(1,1,1,0.5));
 Booms.Add(boom);
 Free;
end;

procedure TSniper.draw(gle : TGLEngine);
var
 angle:single;
begin
 GLE.SetColor(1,1,1,healt/50);
{GLE.Ellipse(x,y,3,3,0,10);
 GLE.Ellipse(x,y-3,3,3,0,10);
 GLE.Ellipse(x-2,y+2,3,3,0,10);
 GLE.Ellipse(x+2,y+2,3,3,0,10);}

 angle:=0;
 If target<>nil then
  angle:=CalcAngle(target.x-x,Target.y-y);

 GLe.DrawImage(x,y,23,29,angle,true,false,ImTank);


if Form1.ShowCaption.Checked then
begin
 Gle.SetColor(1,1,1,0.5);
 Gle.TextOut(x+4,y,Inttostr(Round(healt))+ '%');
end;
end;

procedure TSniper.Faer;
begin

If target<>nil then
If distance<DistanseAtack then
begin    //��������� �� ����
 CountShoot:=CountShoot-1;
 GLE.SetColor(255,0,0,0.3);
 GLE.LineWidth(1);
 GLE.Line(x,y,target.x,target.y);

 if CountShoot<1 then
 begin


 GLE.SetColor(0,0,255,1);
  GLE.LineWidth(5);
  GLE.Line(x,y,target.x,target.y);
  GLE.SetColor(255,255,0,1);
  GLE.LineWidth(2);
  GLE.Line(x,y,target.x,target.y);
  if CountShoot=0 then
  begin
   target.healt:=Round(target.healt-Uron);
   if target.healt<=0 then
   begin
    target.Deat;
    Target:=nil;
   end;
   CountShoot:=SpeedAtack;
  end;
 end;
end;
end;

procedure TSniper.FindTarget;
 var
 i:integer;
 min,mn:real;
 Zombi,ta:TMonstr;
begin
 dangerZombi:=nil;
 target:=nil;
 ta:=nil;
 mn:=50000;
 min:=50000;
 i:=0;
 try
 While i<m.Count do
 begin
  Zombi:=TMonstr(m.Items[i]);
  if SQRT(sqr(Zombi.x-x)+sqr(Zombi.y-y))-Zombi.healt/2<mn then
  begin
   min:=SQRT(sqr(Zombi.x-x)+sqr(Zombi.y-y));
   mn:=min-(Zombi.healt);
   ta:=Zombi;
  end;
  i:=i+1;
 end ;
 except
   ShowMessage('1');
 end;
 target:=ta;
 distance:=min;

 dangerZombi:= GetNearMonstr(DistanceDanger);

 If DistanceDanger<=130 then
 begin
  target:=dangerZombi;
  distance:= DistanceDanger;
 end;

end;

procedure TSniper.Life;
begin
 x:=random(form1.ClientWidth);
 LaserColor.Red:=(50+random(200))/250;
 LaserColor.Green:=(50+random(200))/250;
 LaserColor.Blue:=(50+random(200))/250;
 LaserColor.alpha:=1;
 y:=form1.Panel1.ClientHeight-30;
 healt:=100;
 DistanseAtack:=400;
 Uron:=100;
 SpeedAtack:=50;
 speed:=0.5+random/5;
 CountShoot:=SpeedAtack;
 TypeArmor:=aSniper;
end;

procedure TSniper.Move;
var
 dx,dy:single;
begin
If (dangerZombi<>nil) and (target<>nil)then
begin

if (x>1) and (x<form1.Panel1.ClientWidth) then
 if DistanceDanger<DistanseAtack/3 then
   dx:=x-dangerZombi.x
  else
   dx:=-(x-target.x);

if (y>1) and (y<form1.Panel1.ClientHeight) then
 if DistanceDanger<DistanseAtack/3 then
   dy:=y-dangerZombi.y
  else
   dy:=-(y-target.y);
  NormalVector(dx,dy,speed);
  x:=x+dx;
  y:=y+dy;
  if x<=1 then x:=random(5)+2;
  if x>=form1.Panel1.ClientWidth then x:=form1.Panel1.ClientWidth-random(5)-2;

  if y<=1 then y:=random(5)+2;
  if y>=form1.Panel1.ClientHeight-1 then y:=form1.Panel1.ClientHeight-random(5)-2;
end;
end;

procedure TForm1.GLSceneViewer1Click(Sender: TObject);
begin
 timer1.Enabled:=not timer1.Enabled;
end;

{ TSoldir }

procedure TSoldir.Deat;
var
 boom:Tboom;
begin
 a.Remove(self);
 boom:=Tboom.Create;
 boom.Add(Round(x),round(y),GLE.ColorGL(1,1,1,0.5));
 Booms.Add(boom);
 Free;
end;

procedure TSoldir.draw(gle : TGLEngine);
var
 angle:single;
begin
// GLE.SetColor((100-healt)/100,healt/100,0,1);
 GLE.SetColor(1,1,1,healt/50);
// GLE.Ellipse(x,y,3,5,0,20);
 angle:=0;
 If target<>nil then
  angle:=CalcAngle(target.x-x,Target.y-y);

// GLE.DrawImage(x,y,26,30,angle,true,ImSoldir);
   Gle.DrawAniFrame(x,y,angle,amin);
//  gle.TextOut(x,y,Format('%2.1f',[Rang]));

 if Form1.ShowCaption.Checked then
 begin
  Gle.SetColor(1,1,1,0.5);
  Gle.TextOut(x+4,y,Inttostr(Round(healt))+ '%');
 end;

end;

procedure TSoldir.Faer;
{const
 d=2;
var
 lx,ly:real;

 weapon:TWeapon;
 i,j:integer;  }
begin
If target<>nil then
If distance<DistanseAtack then
begin
{ For j:=1 to 2 do
 begin
  GLE.LineWidth(3);
  lx:=x;
  ly:=y;
  dlx:=(target.x-x)/d;
  dly:=(target.y-y)/d;

 For i:=1 to d-1 do
  begin
   GLE.SetColor(LaserColor);
   lx:=lx+dlx;
   ly:=ly+dly;
  GLE.Line(lx+3-random(6),ly+3-random(6),lx+3-random(6),ly+3-random(6));
 end ;
 end;  }

// bu:=TBullet.Create;
  Attak;
 { bu.Add(x,y,target.x-x,target.y-y,3);
  bullets.Add(bu); }
{ GLE.LineWidth(2);
 GLE.SetColor(LaserColor);
   For i:=1 to d-1 do
    GLE.Bolt(x,y,target.x,target.y);
  GLE.LineWidth(1);
  target.healt:=Round(target.healt-Uron);
  if target.healt<=0 then
  begin
   target.deat;
   Target:=nil;
  end;   }
end;

end;

procedure TSoldir.FindTarget;
var
 i:integer;
 min,mn:real;
 Zombi,ta:TMonstr;
begin
 dangerZombi:=nil;
 target:=nil;
 ta:=nil;
 mn:=50000;
 min:=50000;
 i:=0;
 try
 While i<m.Count do
 begin
  Zombi:=TMonstr(m.Items[i]);
  if SQRT(sqr(Zombi.x-x)+sqr(Zombi.y-y))-Zombi.healt<mn then
  begin
   min:=SQRT(sqr(Zombi.x-x)+sqr(Zombi.y-y));
   mn:=min-(Zombi.healt);
   ta:=Zombi;
  end;
  i:=i+1;
 end ;
 except
   ShowMessage('1');
 end;
 target:=ta;
 distance:=min;

 dangerZombi:= GetNearMonstr(DistanceDanger);

 If DistanceDanger<=100 then
 begin
  target:=dangerZombi;
  distance:= DistanceDanger;
 end;
end;

procedure TSoldir.Life;
begin
 x:=random(form1.ClientWidth);
 TypeArmor:=aSoldir;
 amin:=AnSoldir;
 LaserColor.Red:=(50+random(200))/250;
 LaserColor.Green:=(50+random(200))/250;
 LaserColor.Blue:=(50+random(200))/250;
 LaserColor.alpha:=0.3;
 y:=form1.ClientHeight-3;
 healt:=100;
 DistanseAtack:=200;
 Uron:=10;
 SpeedAtack:=1;
 speed:=0.9+random/3;

 if random>0.5 then
   weapon:=bBullet
 else
   weapon:=bFire;

 if random>0.9then
  weapon:=bBoomBullet;

  sdvig:=random(7)+3;
  delta:=1;
  if  random>=0.5 then
   delta:=-1
end;

procedure TSoldir.Move;
var
 dx,dy:single;
begin
If (dangerZombi<>nil) and (target<>nil)then
begin
 dx:=x-(dangerZombi.x+(delta*distance/sdvig));
 dy:=y-(dangerZombi.y+(delta*distance/sdvig));
if (x>1) and (x<form1.Panel1.ClientWidth) then
 if DistanceDanger>DistanseAtack/2 then
  begin
   dx:=-dx
  end;

if (y>1) and (y<form1.Panel1.ClientHeight) then
 if DistanceDanger>=DistanseAtack/2 then
  begin
   dy:=-dy;
  end;

  NormalVector(dx,dy,speed);

  x:=x+dx;
  y:=y+dy;

  if x<=1 then x:=random(5)+2;
  if x>=form1.Panel1.ClientWidth then x:=form1.Panel1.ClientWidth-random(5)-2;

  if y<=1 then y:=random(5)+2;
  if y>=form1.Panel1.ClientHeight-1 then y:=form1.Panel1.ClientHeight-random(5)-2;
end;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
 sButton2.Left:=Form1.ClientWidth-sButton2.Width-10;
end;

{ Tboom }

procedure Tboom.Add(x, y: integer;c:TGLColor);
begin
 xn:=x;
 yn:=y;
 AllStep:=24;
 step:=1;
 Angle:=Random(360);
 color:=c;
// color:=c;
 aminBoom:=ani;
{ For i:=0 to 30 do
 begin
  Parts[i].x:=x;
  Parts[i].y:=y;
  Parts[i].dx:=(5-random(10))/2;
  Parts[i].dy:=(5-random(10))/2;
  Parts[i].r:=random(3);
 end;  }
end;

procedure Tboom.Draw(gle : TGLEngine);
begin
{ step:=step-1;
 GLE.SetColor(1,0,0,1-(AllStep-step)/AllStep);
 For i:=0 to 30 do
 begin
 GLE.Line(xn,yn,Parts[i].x,Parts[i].y);
  GLE.Ellipse(Parts[i].x,Parts[i].y,Parts[i].r,Parts[i].r,0,10);
  Parts[i].x:=Parts[i].x+Parts[i].dx;
  Parts[i].y:=Parts[i].y+Parts[i].dy;
  Parts[i].dy:=Parts[i].dy*1.2;
  Parts[i].dx:=Parts[i].dx*1.2;
 end;
 if step<0 then
 begin
  booms.Remove(self);
  free;
 end;  }

 gle.SetColor(color);
 gle.SwichBlendMode(bmAdd);
 gle.DrawImage(xn,yn,64,64,0,true,false,ImboomParts[step]);
// gle.DrawAniFrame(xn,yn,Angle,aminBoom);
 gle.SwichBlendMode(bmNormal);
 step:=step+1;
 if step>16 then
 begin
  booms.Remove(self);
  free;
 end;

end;

{ TMedik }

procedure TMedik.Deat;
var
  boom:Tboom;
begin
 a.Remove(self);
 boom:=Tboom.Create;
 boom.Add(Round(x),round(y),GLE.ColorGL(1,1,1,0.5));
 Booms.Add(boom);
 Free;
end;

procedure TMedik.draw(gle : TGLEngine);
begin
 GLE.SetColor(1,1,1,1);
{ GLE.Ellipse(x,y,4,6,0,20);
 GLE.SetColor(0.4,1,0,1);
 GLE.Ellipse(x,y,3,5,0,20);
 GLE.SetColor(1,0,0,1);
 GLE.Line(x-3,y,x+3,y);
 GLE.Line(x,y-3,x,y+3) ;   }
 GLe.DrawImage(x,y,20,20,0,true,false,ImMedik);
if Form1.ShowCaption.Checked then
begin
 Gle.SetColor(1,1,1,0.5);
 Gle.TextOut(x+4,y,Inttostr(Round(healt))+ '%');
end;

end;

procedure TMedik.Faer;
begin
if TargetAr<>nil then
 If distance<DistanseAtack then
  if TargetAr.healt<100 then
   begin
    GLE.SetColor(1,1,1,1);
    GLE.Line(x,y,TargetAr.x,TargetAr.y);

    GLE.SetColor(1,1,1,0.1);
    GLE.Ellipse(TargetAr.x,TargetAr.y,7,7,1,0,20);

    if TargetAr<>nil then
     TargetAr.healt:=TargetAr.healt+uron;
   end
end;

procedure TMedik.FindTarget;
var
 i:integer;
 min,mn:real;
 taa,tta:Tarmor;

begin
 dangerZombi:=nil;
 target:=nil;
 taa:=nil;
 tta:=nil;
 mn:=50000;
 min:=50000;
 i:=0;
 try
 While i<a.Count do
 begin
  taa:=TArmor(a.Items[i]);
  if (taa<>self)and(taa.TypeArmor<>aMedik) then
  if SQRT(sqr(taa.x-x)+sqr(taa.y-y))/10+taa.healt<mn then
  begin
   min:=SQRT(sqr(taa.x-x)+sqr(taa.y-y));
   mn:=min/10+taa.healt;
   tta:=taa;
  end;
  i:=i+1;
 end ;
 except
   ShowMessage('1');
 end;
 distance:=min;
 TargetAr:=tta;

 dangerZombi:= GetNearMonstr(DistanceDanger);
end;

procedure TMedik.Life;
begin
 x:=random(form1.ClientWidth);
 TypeArmor:=aMedik;
 LaserColor.Red:=(50+random(200))/250;
 LaserColor.Green:=(50+random(200))/250;
 LaserColor.Blue:=(50+random(200))/250;
 LaserColor.alpha:=1;
 y:=form1.Panel1.ClientHeight-3;
 healt:=100;
 DistanseAtack:=100;
 Uron:=2;
 SpeedAtack:=1;
 speed:=1.2+random/3;
end;

procedure TMedik.Move;
var
 dx,dy:single;
begin
If (dangerZombi<>nil) and (TargetAr<>nil)then
begin
if (x>1) and (x<form1.Panel1.ClientWidth) then
 if DistanceDanger<DistanseAtack then
   dx:=x-dangerZombi.x
  else
   dx:=-(x-TargetAr.x);
  if distance<10 then
   dx:=(x-TargetAr.x);

if (y>1) and (y<form1.Panel1.ClientHeight) then
 if DistanceDanger<DistanseAtack then
   dy:=y-dangerZombi.y
  else
   dy:=-(y-TargetAr.y);

   if distance<10 then
   dy:=(y-TargetAr.y);

  NormalVector(dx,dy,speed);
  x:=x+dx;
  y:=y+dy;
  if x<=1 then x:=random(5)+2;
  if x>=form1.Panel1.ClientWidth then x:=form1.Panel1.ClientWidth-random(5)-2;

  if y<=1 then y:=random(5)+2;
  if y>=form1.Panel1.ClientHeight-1 then y:=form1.Panel1.ClientHeight-random(5)-2;
 end;
end;

{ TQueen }

procedure TQueen.Attak;
var
 Zombi:Tzombi;
 Grom:TGrom;
begin
 TimeLife:=TimeLife-1;
 if TimeLife<0 then
 if random<0.8 then
  begin
   TimeLife:=TimeForLife;
   Zombi:=Tzombi.Create;
   Zombi.Life;
   Zombi.x:=x;
   Zombi.y:=y+round(healt/20);
   m.Add(Zombi);
 end
 else
  begin
   TimeLife:=TimeForLife;
   Grom:=TGrom.Create;
   Grom.Life;
   Grom.x:=x;
   Grom.y:=y+round(healt/20);
   m.Add(Grom);
 end

end;

procedure TQueen.Deat;
var
  boom:Tboom;
begin
 m.Remove(self);
 boom:=Tboom.Create;
 boom.Add(Round(x),round(y),GLE.ColorGL(random,random,random,0.5));
 Booms.Add(boom);
 Free;
end;

procedure TQueen.Draw(gle : TGLEngine);
var
 angle:single;
begin
 GLE.SetColor(ColorZombi);

 angle:=0;
 If target<>nil then
  angle:=CalcAngle(target.x-x,Target.y-y);

 GLe.DrawImage(x,y,10+healt/20,10+healt/10,angle,true,false,ImQueen);
{ GLE.Line(x-healt/20,y-healt/20,x+healt/20,y+healt/20);
 GLE.Line(x+healt/20,y-healt/20,x-healt/20,y+healt/20);

 GLE.SetColor(0,1,1,0.3);
 GLE.Ellipse(x-healt/20,y-healt/20,TimeLife/10,TimeLife/10,0,10);
 GLE.Ellipse(x+healt/20,y-healt/20,TimeLife/10,TimeLife/10,0,10);
 GLE.Ellipse(x-healt/20,y+healt/20,TimeLife/10,TimeLife/10,0,10);
 GLE.Ellipse(x+healt/20,y+healt/20,TimeLife/10,TimeLife/10,0,10);

 GLE.SetColor(0,0,1,0.3);
 GLE.Ellipse(x,y,healt/20,healt/20,0,10);   }
if Form1.ShowCaption.Checked then
begin
 Gle.SetColor(1,1,1,0.5);
 Gle.TextOut(x+4,y,Inttostr(Round(healt))+ '%');
end;
end;

procedure TQueen.FindTarget;
begin
 target:=GetNearArmor(Distance);
 If target<>nil then
 begin
  dx:=-(target.x-x);
  dy:=-(target.y-y);
  if distance>300 then
   begin
    dx:=-dx;
    dy:=-dy;
   end;
  NormalVector(dx,dy,speed);
 end;
end;

function TQueen.GetPosition: TPoint;
begin

end;

procedure TQueen.Life;
begin
 TypeMonstr:=mQueen;
 TimeForLife:=70+Random(30);
 TimeLife:=TimeForLife;
 x:=random(Form1.Width);

 ColorZombi.Red:=(100+random(150))/255;
 ColorZombi.Green:=0;
 ColorZombi.Blue:=(100+random(150))/255;
 ColorZombi.alpha:=1;

 y:=6;//random(Form1.Height);
 healt:=random(500);
 speed:=1+random/2;
 dx:=3-random(6);
 dy:=3-random(6);
 FindTarget

end;

procedure TQueen.Move;
begin
 if healt<700 then
  healt:=healt+1;

 x:=x+dx;
 y:=y+dy;

 if x<=1 then x:=random(5)+2;
  if x>=form1.Panel1.ClientWidth then x:=form1.Panel1.ClientWidth-random(5)-2;

 if y<=1 then y:=random(5)+2;
  if y>=form1.Panel1.ClientHeight-1 then y:=form1.Panel1.ClientHeight-random(5)-2;
end;

procedure TForm1.Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
 If a.Count>0 then
begin
 Tarmor(a.Items[0]).x:=x;
 Tarmor(a.Items[0]).y:=y;
end
end;

procedure TForm1.Panel1Click(Sender: TObject);
begin
 Timer1.Enabled:=Not Timer1.Enabled;
end;

procedure TForm1.Panel1Resize(Sender: TObject);
begin
if GLE.dcvis<>0 then
 GLE.Resize(Panel1.ClientWidth,Panel1.ClientHeight);
end;

{ TGrom }

procedure TGrom.Attak;
var
 dx,dy:single;
begin
If distance<130 then
 If CountShoot  = 0 then
 begin
  CountShoot:=15;

{  glc.MoveTo(x,y);
  glc.PenWidth:=3;
  glc.PenColor:=RGB(0,255,0);
  glc.LineTo(Round(target.x),Round(target.y));
  glc.PenWidth:=1;
  glc.PenColor:=clBlack;   }

  GLE.LineWidth(3);
  GLE.SetColor(0,1,0,0.8);
  GLE.Line(x,y,target.x,target.y);
  GLE.LineWidth(1);

  dx:= x-target.x;
  dy:= y-target.y;
  NormalVector(dx,dy,10);
  target.x:=target.x+dx;
  target.y:=target.y+dy;
 If target<>nil then
 begin
  target.healt:=target.healt-10;
  if target.healt<=0 then
  begin
   target.Deat;
   Target:=nil;
  end;
 end

end
 else
  CountShoot:=CountShoot-1;
end;

procedure TGrom.Deat;
var
 boom:Tboom;
begin
 m.Remove(self);
 boom:=Tboom.Create;
 boom.Add(Round(x),round(y),GLE.ColorGL(1,1,1,0.5));
 Booms.Add(boom);

 // ����� �� �����
 Gle.BeginRenderToTex(Im,1024,601);
 // gle.SetColor(1,1,1,0.005);
 // gle.DrawImage(0,0,form1.Panel1.ClientWidth,form1.Panel1.ClientHeight,0,false,imb);
  gle.SetColor(0,1,0,0.8);
  gle.DrawImage(x, y,40+random(20),40+random(20),Random(360),true,false,ImBlood);
 gle.EndRenderToTex;

 Free;
end;

procedure TGrom.Draw(gle : TGLEngine);
var
 angle:single;
begin

{  glc.PenColor:=RGB(20,20,120);
   glc.FillEllipse(Round(x),round(y),round(healt/20),round(healt/20));
   glc.PenColor:=ColorZombi;
   glc.FillEllipse(Round(x),round(y),round(healt/20),round(healt/40));
   glc.FillEllipse(Round(x),round(y),round(healt/40),round(healt/20));
    glc.PenColor:=Rgb(255,0,0);
    glc.FillEllipse(Round(x),round(y),CountShoot div 2,CountShoot div 2);
//   glc.FillEllipse(Round(x+healt/40),round(y),round(healt/40),round(healt/20));
   glc.PenColor:=clBlack;
  glc.Ellipse(Round(x),round(y),round(healt/20),round(healt/40));
// glc.Rectangle(Round(x-healt/200),Round(y-healt/200),Round(x+healt/200),Round(y+healt/200));
}

{ GLE.SetColor(0.1,0.1,0.5,0.3);
 GLE.Ellipse(x,y,healt/20,healt/20,0,10);  }

 GLE.SetColor(ColorZombi);

  angle:=0;
 If target<>nil then
  angle:=CalcAngle(target.x-x,Target.y-y);

 GLe.DrawImage(x,y,20+healt/20,20+healt/20,angle,true,false,ImGrom);
{ GLE.Ellipse(x,y,healt/20,healt/40,0,10);
 GLE.Ellipse(x,y,healt/40,healt/20,0,10);

 GLE.SetColor(1,0,0,0.3);
 GLE.Ellipse(x,y,CountShoot div 2,CountShoot div 2,0,10);    }

if Form1.ShowCaption.Checked then
begin
 Gle.SetColor(1,1,1,0.5);
 Gle.TextOut(x+4,y,Inttostr(Round(healt))+ '%');
end;

end;

procedure TGrom.FindTarget;
begin
target:=GetNearArmor(Distance);
If target<>nil then
 begin
  dx:=-(target.x-x);
  dy:=-(target.y-y);
  if distance>107 then
   begin
    dx:=-dx;
    dy:=-dy;
   end;
  NormalVector(dx,dy,speed);
 end;
end;

function TGrom.GetPosition: TPoint;
begin

end;

procedure TGrom.Life;
begin
 TypeMonstr:=mGrom;
 CountShoot:=15;
 x:=(Form1.Width/2)-100+random(200);

 ColorZombi.Red:=(100+random(150))/255;
 ColorZombi.Green:=(100+random(150))/255;;
 ColorZombi.Blue:=0;
 ColorZombi.alpha:=0.6;

 y:=6;//random(Form1.Height);
 healt:=200+random(100);
 speed:=0.6+random/2;
 dx:=3-random(6);
 dy:=3-random(6);
 FindTarget

end;

procedure TGrom.Move;
begin
 x:=x+dx;
 y:=y+dy;

 if x<=1 then x:=random(5)+2;
  if x>=form1.Panel1.ClientWidth then x:=form1.Panel1.ClientWidth-random(5)-2;

 if y<=1 then y:=random(5)+2;
  if y>=form1.Panel1.ClientHeight-1 then y:=form1.Panel1.ClientHeight-random(5)-2;

end;

{ TMonstr }

function TMonstr.GetNearArmor(Var distance:single): Tarmor;
var
 i:integer;
 min:real;
 Armor:TArmor;
begin
 min:=50000;
 i:=0;
 result:=nil;
 While i<a.Count do
 begin
 Armor:=TArmor(a.Items[i]);
 if SQRT(sqr(Armor.x-x)+sqr(Armor.y-y))<min then
 begin
  min:=SQRT(sqr(Armor.x-x)+sqr(Armor.y-y));
  result:=Armor;
 end;
  i:=i+1;
 end;
  distance:=min;
end;

{ TBullet }

procedure TBullet.Add(ParentArmor:TArmor;x,y,dx,dy:single);
begin
 Self.Parent:= ParentArmor;
 self.x:=x;
 self.y:=y;
 self.dx:=dx;
 self.dy:=dy;
 self.speed:=6;
 normalvector(self.dx,self.dy,self.speed);
 self.MaxDistance:=200;
 self.damage:=1;
 self.distance:=0;
 self.TypeBullet:= bBullet;
end;

procedure TBullet.draw;
begin
 gle.SwichBlendMode(bmAdd);
 gle.SetColor(0,0,1,1-distance/MaxDistance);
 gle.PointSize(3);
 gle.Point(x,y);
 gle.PointSize(1);
 gle.SetColor(1,1,1,1-distance/MaxDistance);
 gle.Point(x,y);
 gle.SwichBlendMode(bmNormal);
end;

procedure TBullet.move;
var
 i:integer;
 zombi:TMonstr;
begin
 x:=x+dx;
 y:=y+dy;
 distance:=distance+Round(sqrt(dx*dx+dy*dy));
 i:=0;
 While i<m.Count do
 begin
  Zombi:=TMonstr(m.Items[i]);
  if Zombi<>nil then
  if SQRT(sqr(Zombi.x-x)+sqr(Zombi.y-y))<10+Zombi.healt/10 then
  begin
   Zombi.healt:=Zombi.healt-damage;
   if Zombi.healt<=0 then
   begin
    Zombi.Deat;
    Zombi:=nil;
    Parent.Rang:=Parent.Rang+0.1;
    kill;
    exit;
   end;
  end;
  i:=i+1;
 end;

 if (distance>=MaxDistance)or (x<0) or (x>=form1.Panel1.ClientWidth) or (y<0) or (y>=form1.Panel1.ClientHeight) then
  kill;

end;

{ TFire }

procedure TFire.Add(ParentArmor:TArmor;x, y, dx, dy: single);
begin
 Self.Parent:= ParentArmor;
 self.x:=x;
 self.y:=y;
 self.dx:=dx;
 self.dy:=dy;
 self.speed:=4;
 normalvector(self.dx,self.dy,speed);

 self.MaxDistance:=100;
 self.damage:=2;
 self.distance:=0;
 self.TypeBullet:= bFire;
end;

procedure TFire.draw;
begin
 gle.SwichBlendMode(bmAdd);
 gle.SetColor(random/2+0.5,random/3,random/5,1-distance/MaxDistance);
 gle.DrawImage(x,y,20,20,0,true,false,ImFire);
 gle.SwichBlendMode(bmNormal);
end;

procedure TFire.move;
var
 i:integer;
 zombi:TMonstr;
begin
 x:=x+dx;
 y:=y+dy;
 distance:=distance+Round(sqrt(dx*dx+dy*dy));
 i:=0;
 While i<m.Count do
 begin
  Zombi:=TMonstr(m.Items[i]);
  if Zombi<>nil then
  if SQRT(sqr(Zombi.x-x)+sqr(Zombi.y-y))<10+Zombi.healt/10 then
  begin
   Zombi.healt:=Zombi.healt-damage;
   if Zombi.healt<=0 then
   begin
    Zombi.Deat;
    Zombi:=nil;
    Parent.Rang:=Parent.Rang+0.1;
    kill;
    exit;
   end;
  end;
  i:=i+1;
 end;

 if (distance>=Maxdistance)or (x<0) or (x>=form1.Panel1.ClientWidth) or (y<0) or (y>=form1.Panel1.ClientHeight) then
  kill;

end;

{ TWeapon }

procedure TWeapon.kill;
begin
 Bullets.Remove(self);
 free
end;

{ TBoomBullet }

procedure TBoomBullet.Add(ParentArmor: TArmor; x, y, dx, dy,size: single);
begin
 Self.Parent:= ParentArmor;
 self.size := size;
 self.x:=x;
 self.y:=y;
 self.dx:=dx;
 self.dy:=dy;
 self.speed:=5;
 normalvector(self.dx,self.dy,self.speed);
 self.MaxDistance:=70;
 self.damage:=30;
 self.distance:=0;
 self.TypeBullet:= bBoomBullet;
end;

procedure TBoomBullet.draw;
begin
 gle.SwichBlendMode(bmAdd);
 gle.SetColor(0,1,0,0.8);
// gle.Ellipse(x,y,size/10,size/10,1,0,5);
 gle.DrawImage(x,y,size/5,size/5,0,true,false,ImFire);
 gle.SwichBlendMode(bmNormal);
end;

procedure TBoomBullet.move;
 var
 i:integer;
 zombi:TMonstr;
 bbu:TBoomBullet;
begin
 x:=x+dx;
 y:=y+dy;
 distance:=distance+Round(sqrt(dx*dx+dy*dy));

 size:=size-1;

 if size < 3 then
 begin
  kill;
  exit;
 end;

 i:=0;
 While i<m.Count do
 begin
  Zombi:=TMonstr(m.Items[i]);
  if Zombi<>nil then
  if SQRT(sqr(Zombi.x-x)+sqr(Zombi.y-y))<10+Zombi.healt/10 then
  begin
   Zombi.healt:=Zombi.healt-Round(damage*size/100);

   bbu:=TBoomBullet.Create;
   bbu.Add(parent,x,y,0.5-random,0.5-random,size/1.5);
   bullets.add(bbu);

   bbu:=TBoomBullet.Create;
   bbu.Add(parent,x,y,0.5-random,0.5-random,size/1.5);
   bullets.add(bbu);

   bbu:=TBoomBullet.Create;
   bbu.Add(parent,x,y,0.5-random,0.5-random,size/1.5);
   bullets.add(bbu);

   bbu:=TBoomBullet.Create;
   bbu.Add(parent,x,y,0.5-random,0.5-random,size/1.5);
   bullets.add(bbu);

   if Zombi.healt<=0 then
   begin
    Zombi.Deat;
    Zombi:=nil;
    Parent.Rang:=Parent.Rang+0.1;


   end;

   kill;
   exit;

 //  Add(parent,x,y,-0.01,0 );
  //  Add(parent,x,y,0, 0.01 );
  //  Add(parent,x,y,0,-0.01 );

  end;
  i:=i+1;
 end;

 if (distance>=MaxDistance)or (x<0) or (x>=form1.Panel1.ClientWidth) or (y<0) or (y>=form1.Panel1.ClientHeight) then
  kill;


end;

end.


