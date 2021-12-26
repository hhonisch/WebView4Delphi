unit uMainForm;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes,
  Graphics, Controls, Forms, Dialogs, ExtCtrls, ComCtrls, StdCtrls, ImgList, ToolWin,
  uWVBrowser, uWVWinControl, uWVWindowParent, uWVTypes, uWVConstants, uWVTypeLibrary,
  uWVLibFunctions, uWVLoader, uWVInterfaces, uWVCoreWebView2Args, uWVBrowserBase;

type
  TMainForm = class(TForm)
    WVWindowParent1: TWVWindowParent;
    Timer1: TTimer;
    WVBrowser1: TWVBrowser;
    ImageList1: TImageList;
    ToolBar1: TToolBar;
    NewBtn: TToolButton;
    OpenBtn: TToolButton;
    SaveBtn: TToolButton;
    Separator1: TToolButton;
    BoldBtn: TToolButton;
    ItalicBtn: TToolButton;
    UnderlineBtn: TToolButton;
    StrikethroughBtn: TToolButton;
    Separator2: TToolButton;
    AlignLeftBtn: TToolButton;
    AlignCenterBtn: TToolButton;
    AlignRightBtn: TToolButton;
    AlignJustifyBtn: TToolButton;
    Separator3: TToolButton;
    LinkBtn: TToolButton;
    Separator4: TToolButton;
    UnorderedListBtn: TToolButton;
    OrderedListBtn: TToolButton;
    Separator5: TToolButton;
    TextColorBtn: TToolButton;
    FillColorBtn: TToolButton;
    Separator6: TToolButton;
    RemoveFormatBtn: TToolButton;
    Separator7: TToolButton;
    OutdentBtn: TToolButton;
    IndentBtn: TToolButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    ColorDialog1: TColorDialog;

    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);

    procedure WVBrowser1AfterCreated(Sender: TObject);
    procedure WVBrowser1DocumentTitleChanged(Sender: TObject);
    procedure WVBrowser1InitializationError(Sender: TObject; aErrorCode: HRESULT; const aErrorMessage: wvstring);
    procedure WVBrowser1RetrieveHTMLCompleted(Sender: TObject; aResult: Boolean; const aHTML: wvstring);

    procedure BoldBtnClick(Sender: TObject);
    procedure ItalicBtnClick(Sender: TObject);
    procedure UnderlineBtnClick(Sender: TObject);
    procedure StrikethroughBtnClick(Sender: TObject);
    procedure AlignLeftBtnClick(Sender: TObject);
    procedure AlignCenterBtnClick(Sender: TObject);
    procedure AlignRightBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure NewBtnClick(Sender: TObject);
    procedure OpenBtnClick(Sender: TObject);
    procedure LinkBtnClick(Sender: TObject);
    procedure AlignJustifyBtnClick(Sender: TObject);
    procedure UnorderedListBtnClick(Sender: TObject);
    procedure OrderedListBtnClick(Sender: TObject);
    procedure IndentBtnClick(Sender: TObject);
    procedure TextColorBtnClick(Sender: TObject);
    procedure FillColorBtnClick(Sender: TObject);
    procedure RemoveFormatBtnClick(Sender: TObject);
    procedure OutdentBtnClick(Sender: TObject);

  protected
    procedure WMMove(var aMessage : TWMMove); message WM_MOVE;
    procedure WMMoving(var aMessage : TMessage); message WM_MOVING;

  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

// This demo shows how to create a simple editor using a browser.

// It's possible to add many more editor commands available with the JavaScript function called 'execCommand'
// https://developer.mozilla.org/en-US/docs/Web/API/Document/execCommand

// There are several TODO comments with some missing features that all editors should have

// This demo includes some icons from "Material Design Icons", made by Google ( https://github.com/google/material-design-icons )

// This demo loads a local HTML file loaded using a virtual host in a WebView2 browser.

// This file is located in the WebView4Delphi\assets\ directory.

// This demo maps the customhost.test domain to the ..\assets directory by calling
// TWVBrowser.SetVirtualHostNameToFolderMapping inside the TWVBrowser.OnAfterCreated event.

// Read this for all the details about this feature :
// https://docs.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2_3?view=webview2-1.0.1020.30#setvirtualhostnametofoldermapping

uses
  uImageSelection;

procedure TMainForm.FormShow(Sender: TObject);
begin
  if GlobalWebView2Loader.InitializationError then
    showmessage(UTF8Encode(GlobalWebView2Loader.ErrorMessage))
   else
    if GlobalWebView2Loader.Initialized then
      WVBrowser1.CreateBrowser(WVWindowParent1.Handle)
     else
      Timer1.Enabled := True;
end;

procedure TMainForm.WVBrowser1AfterCreated(Sender: TObject);
var
  TempScript: wvstring;
begin
  WVWindowParent1.UpdateSize;
  Caption := 'EditorBrowser';
  WVBrowser1.SetVirtualHostNameToFolderMapping('customhost.test', '..\assets', COREWEBVIEW2_HOST_RESOURCE_ACCESS_KIND_ALLOW);

  // This code enables the editor mode when a web page is loaded
  TempScript := 'document.designMode = "on";';
  WVBrowser1.AddScriptToExecuteOnDocumentCreated(TempScript);
end;

procedure TMainForm.WVBrowser1DocumentTitleChanged(Sender: TObject);
begin
  Caption := 'EditorBrowser - ' + WVBrowser1.DocumentTitle;
end;

procedure TMainForm.WVBrowser1InitializationError(Sender: TObject;
  aErrorCode: HRESULT; const aErrorMessage: wvstring);
begin
  showmessage(aErrorMessage);
end;

procedure TMainForm.WVBrowser1RetrieveHTMLCompleted(Sender: TObject;
  aResult: Boolean; const aHTML: wvstring);
var
  TempHTML : TStringList;
begin
  TempHTML := nil;

  SaveDialog1.Filter     := 'HTML files (*.html)|*.html';
  SaveDialog1.DefaultExt := 'html';

  if SaveDialog1.Execute and (length(SaveDialog1.FileName) > 0) then
    try
      TempHTML      := TStringList.Create;
      TempHTML.Text := UTF8Encode(aHTML);
      TempHTML.SaveToFile(SaveDialog1.FileName);
    finally
      if assigned(TempHTML) then
        FreeAndNil(TempHTML);
    end;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;

  if GlobalWebView2Loader.Initialized then
    WVBrowser1.CreateBrowser(WVWindowParent1.Handle)
   else
    Timer1.Enabled := True;
end;

procedure TMainForm.WMMove(var aMessage : TWMMove);
begin
  inherited;

  if (WVBrowser1 <> nil) then
    WVBrowser1.NotifyParentWindowPositionChanged;
end;

procedure TMainForm.WMMoving(var aMessage : TMessage);
begin
  inherited;

  if (WVBrowser1 <> nil) then
    WVBrowser1.NotifyParentWindowPositionChanged;
end;

procedure TMainForm.FillColorBtnClick(Sender: TObject);
var
  TempCode, TempHexColor : string;
begin
  if ColorDialog1.execute then
    begin
      TempHexColor := '#' + IntToHex(GetRValue(ColorDialog1.Color), 2) +
                            IntToHex(GetGValue(ColorDialog1.Color), 2) +
                            IntToHex(GetBValue(ColorDialog1.Color), 2);

      TempCode     := 'document.execCommand("backColor", false, "' + TempHexColor + '");';

      WVBrowser1.ExecuteScript(TempCode);
    end;
end;

procedure TMainForm.TextColorBtnClick(Sender: TObject);
var
  TempCode, TempHexColor : string;
begin
  if ColorDialog1.execute then
    begin
      TempHexColor := '#' + IntToHex(GetRValue(ColorDialog1.Color), 2) +
                            IntToHex(GetGValue(ColorDialog1.Color), 2) +
                            IntToHex(GetBValue(ColorDialog1.Color), 2);

      TempCode     := 'document.execCommand("foreColor", false, "' + TempHexColor + '");';

      WVBrowser1.ExecuteScript(TempCode);
    end;
end;

procedure TMainForm.AlignCenterBtnClick(Sender: TObject);
var
  TempCode : string;
begin
  TempCode := 'document.execCommand("justifyCenter", false, null);';

  WVBrowser1.ExecuteScript(TempCode);
end;

procedure TMainForm.AlignJustifyBtnClick(Sender: TObject);
var
  TempCode : string;
begin
  TempCode := 'document.execCommand("justifyFull", false, null);';

  WVBrowser1.ExecuteScript(TempCode);
end;

procedure TMainForm.AlignLeftBtnClick(Sender: TObject);
var
  TempCode : string;
begin
  TempCode := 'document.execCommand("justifyLeft", false, null);';

  WVBrowser1.ExecuteScript(TempCode);
end;

procedure TMainForm.AlignRightBtnClick(Sender: TObject);
var
  TempCode : string;
begin
  TempCode := 'document.execCommand("justifyRight", false, null);';

  WVBrowser1.ExecuteScript(TempCode);
end;

procedure TMainForm.BoldBtnClick(Sender: TObject);
var
  TempCode : string;
begin
  TempCode := 'document.execCommand("bold", false, null);';

  WVBrowser1.ExecuteScript(TempCode);
end;

procedure TMainForm.IndentBtnClick(Sender: TObject);
var
  TempCode : string;
begin
  TempCode := 'document.execCommand("indent", false, null);';

  WVBrowser1.ExecuteScript(TempCode);
end;

procedure TMainForm.ItalicBtnClick(Sender: TObject);
var
  TempCode : string;
begin
  TempCode := 'document.execCommand("italic", false, null);';

  WVBrowser1.ExecuteScript(TempCode);
end;

procedure TMainForm.LinkBtnClick(Sender: TObject);
var
  TempCode, TempURL : string;
begin
  // TODO: Replace InputBox
  TempURL  := inputbox('Type the URL used in the link', 'URL : ', 'https://www.briskbard.com');
  TempCode := 'document.execCommand("createLink", false, "' + TempURL + '");';

  WVBrowser1.ExecuteScript(TempCode);
end;

procedure TMainForm.SaveBtnClick(Sender: TObject);
begin
  WVBrowser1.RetrieveHTML;
end;

procedure TMainForm.StrikethroughBtnClick(Sender: TObject);
var
  TempCode : string;
begin
  TempCode := 'document.execCommand("strikeThrough", false, null);';

  WVBrowser1.ExecuteScript(TempCode);
end;

procedure TMainForm.UnderlineBtnClick(Sender: TObject);
var
  TempCode : string;
begin
  TempCode := 'document.execCommand("underline", false, null);';

  WVBrowser1.ExecuteScript(TempCode);
end;

procedure TMainForm.UnorderedListBtnClick(Sender: TObject);
var
  TempCode : string;
begin
  TempCode := 'document.execCommand("insertUnorderedList", false, null);';

  WVBrowser1.ExecuteScript(TempCode);
end;

procedure TMainForm.OpenBtnClick(Sender: TObject);
begin
  OpenDialog1.Filter := 'HTML Files (*.html)|*.HTML';

  if OpenDialog1.Execute then
    WVBrowser1.Navigate('file:///' + OpenDialog1.FileName); // TODO: The URL should be encoded
end;

procedure TMainForm.OrderedListBtnClick(Sender: TObject);
var
  TempCode : string;
begin
  TempCode := 'document.execCommand("insertOrderedList", false, null);';

  WVBrowser1.ExecuteScript(TempCode);
end;

procedure TMainForm.OutdentBtnClick(Sender: TObject);
var
  TempCode : string;
begin
  TempCode := 'document.execCommand("outdent", false, null);';

  WVBrowser1.ExecuteScript(TempCode);
end;

procedure TMainForm.RemoveFormatBtnClick(Sender: TObject);
var
  TempCode : string;
begin
  TempCode := 'document.execCommand("removeFormat", false, null);';

  WVBrowser1.ExecuteScript(TempCode);
end;

procedure TMainForm.NewBtnClick(Sender: TObject);
begin
  // TODO: Before clearing the document we should notify the user if the document has unsaved changes
  WVBrowser1.Navigate('about:blank');
end;

initialization
  GlobalWebView2Loader                := TWVLoader.Create(nil);
  GlobalWebView2Loader.UserDataFolder := ExtractFileDir(Application.ExeName) + '\CustomCache';
  GlobalWebView2Loader.StartWebView2;

end.