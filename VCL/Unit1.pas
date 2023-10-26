unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.CastleControl, CastleUIControls, CastleVectors, CastleGLUtils, CastleColors,
  Vcl.StdCtrls;

type
  TCastleApp = class(TCastleView)
    procedure Render; override; // TCastleUserInterface
  end;

  TForm1 = class(TForm)
    CastleControl1: TCastleControl;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    GLWin: TCastleControl;
    GLView: TCastleApp;
    function FindCastleControls(o: TObject): TArray<TCastleControl>;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  IsCastleControlOnForm: Boolean;

implementation

{$R *.dfm}

uses System.Generics.Collections;

procedure TForm1.FormCreate(Sender: TObject);
var
  c: TArray<TCastleControl>;
begin
  IsCastleControlOnForm := True;
  c := FindCastleControls(Self);
  if Length(c) = 0 then
    begin
      IsCastleControlOnForm := False;
      GLWin := TCastleControl.Create(Self)
    end
  else
    GLWin := c[0];

  GLWin.Parent := Form1;
  GLWin.Align := alClient;
  GLView := TCastleApp.Create(GLWin);
  GLWin.Container.View := GLView;
end;

procedure TCastleApp.Render;
var
  Points: array[0..3] of TVector2;
begin
  inherited;
  Points[0] := Vector2(0, Container.UnscaledHeight / 2);
  Points[1] := Vector2(Container.UnscaledWidth, Container.UnscaledHeight / 2);
  Points[2] := Vector2(Container.UnscaledWidth / 2, 0);
  Points[3] := Vector2(Container.UnscaledWidth / 2, Container.UnscaledHeight);

  if IsCastleControlOnForm then
    DrawPrimitive2D(pmLines, Points, Green)
  else
    DrawPrimitive2D(pmLines, Points, Red);
end;

function TForm1.FindCastleControls(o: TObject): TArray<TCastleControl>;
var
  i: Integer;
begin
  Result := TArray<TCastleControl>.Create();
  for i:= 0 to ComponentCount - 1 do
    begin
      if Components[i] is TCastleControl then
        begin
          SetLength(Result, Length(Result) + 1);
          Result[Length(Result) - 1] := TCastleControl(Components[i]);
        end;

    end;

end;

end.
