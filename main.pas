unit Main;

{$mode objfpc}{$H+}

interface

uses
  DiscordRPC, Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, Menus, IniFiles, DateUtils;

type

  { TRPCForm }

  TRPCForm = class(TForm)
    MainMenu1: TMainMenu;
    MenuHelp: TMenuItem;
    MenuHowToUse: TMenuItem;
    MenuAbout: TMenuItem;
    MenuLoadProfile: TMenuItem;
    MenuSaveProfile: TMenuItem;
    MenuProfiles: TMenuItem;
    TrayMenuClose: TMenuItem;
    TrayMenuOpen: TMenuItem;
    OpenINI: TOpenDialog;
    PopupMenu1: TPopupMenu;
    SaveINI: TSaveDialog;
    timeIndex: TComboBox;
    EnableRPC: TButton;
    startTime: TLabeledEdit;
    endTime: TLabeledEdit;
    ShutdownRPC: TButton;
    LoadProfile: TButton;
    SaveProfile: TButton;
    Time: TGroupBox;
    ProfileBox: TGroupBox;
    details: TLabeledEdit;
    partyMax: TLabeledEdit;
    AppBox: TGroupBox;
    ApplicationID: TLabeledEdit;
    sublabel: TBoundLabel;
    PartyInfo: TGroupBox;
    state: TLabeledEdit;
    partySize: TLabeledEdit;
    StatusBox: TGroupBox;
    ImageBox: TGroupBox;
    largeImageKey: TLabeledEdit;
    largeImageText: TLabeledEdit;
    smallImageKey: TLabeledEdit;
    smallImageText: TLabeledEdit;
    TrayIcon: TTrayIcon;
    procedure EnableRPCClick(Sender: TObject);
    procedure endTimeChange(Sender: TObject);
    procedure endTimeKeyPress(Sender: TObject; var Key: char);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormWindowStateChange(Sender: TObject);
    procedure LoadProfileClick(Sender: TObject);
    procedure MenuAboutClick(Sender: TObject);
    procedure MenuHowToUseClick(Sender: TObject);
    procedure MenuLoadProfileClick(Sender: TObject);
    procedure MenuSaveProfileClick(Sender: TObject);
    procedure TrayMenuCloseClick(Sender: TObject);
    procedure TrayMenuOpenClick(Sender: TObject);
    procedure partyMaxChange(Sender: TObject);
    procedure partyMaxKeyPress(Sender: TObject; var Key: char);
    procedure partySizeChange(Sender: TObject);
    procedure partySizeKeyPress(Sender: TObject; var Key: char);
    procedure SaveProfileClick(Sender: TObject);
    procedure ShutdownRPCClick(Sender: TObject);
    procedure startTimeChange(Sender: TObject);
    procedure startTimeKeyPress(Sender: TObject; var Key: char);
    procedure timeIndexChange(Sender: TObject);
    procedure TrayIconClick(Sender: TObject);
  private

  public

  end;

  TCallback = procedure;

var
  RPCForm: TRPCForm;
  RPCActive: boolean = False;
  Version: String = '0.61';

implementation

{$R *.lfm}

{ TRPCForm }

procedure EventReady();
begin
  ShowMessage('Ready!');
end;

procedure EventDisconnected();
begin
  ShowMessage('Disconnected!');
end;

procedure EventError();
begin
  ShowMessage('Errored out!');
end;

procedure TRPCForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var
  Settings: TINIFile;
begin
  Settings := TINIFile.Create('LastSettings.ini');
  try
    Settings.WriteString('MAIN', 'AppID', ApplicationID.Text);
    Settings.WriteString('STATUS', 'state', state.Text);
    Settings.WriteString('STATUS', 'details', details.Text);
    Settings.WriteString('IMAGE', 'smallImageKey', smallImageKey.Text);
    Settings.WriteString('IMAGE', 'largeImageKey', largeImageKey.Text);
    Settings.WriteString('IMAGE', 'smallImageText', smallImageText.Text);
    Settings.WriteString('IMAGE', 'largeImageText', largeImageText.Text);
    Settings.WriteString('PARTY', 'partySize', partySize.Text);
    Settings.WriteString('PARTY', 'partyMax', partyMax.Text);
    Settings.WriteString('TIME', 'startTime', startTime.Text);
    Settings.WriteString('TIME', 'endTime', endTime.Text);
    Settings.WriteString('TIME', 'timeIndex', IntToStr(timeIndex.ItemIndex));
  finally
    Settings.Free;
  end;
end;

procedure TRPCForm.FormCreate(Sender: TObject);
var
  Settings: TINIFile;
begin
  Settings := TINIFile.Create('LastSettings.ini');
  try
    ApplicationID.Text := Settings.ReadString('MAIN', 'AppID', '');
    state.Text := Settings.ReadString('STATUS', 'state', '');
    details.Text := Settings.ReadString('STATUS', 'details', '');
    smallImageKey.Text := Settings.ReadString('IMAGE', 'smallImageKey', '');
    largeImageKey.Text := Settings.ReadString('IMAGE', 'largeImageKey', '');
    smallImageText.Text := Settings.ReadString('IMAGE', 'smallImageText', '');
    largeImageText.Text := Settings.ReadString('IMAGE', 'largeImageText', '');
    partySize.Text := Settings.ReadString('PARTY', 'partySize', '0');
    partyMax.Text := Settings.ReadString('PARTY', 'partyMax', '0');
    startTime.Text := Settings.ReadString('TIME', 'startTime', '0');
    endTime.Text := Settings.ReadString('TIME', 'endTime', '0');
    timeIndex.ItemIndex := StrToInt(Settings.ReadString('TIME', 'timeIndex', '0'));
  finally
    Settings.Free;
  end;
  if timeIndex.ItemIndex = 3 then
  begin
    startTime.Enabled := True;
    endTime.Enabled := True;
    endTime.EditLabel.Caption := 'End Time(Epoch Seconds)';
  end;
  if timeIndex.ItemIndex = 2 then
  begin
    startTime.Enabled := False;
    endTime.Enabled := True;
    endTime.EditLabel.Caption := 'Timer(In Seconds)';
  end;
  //Disable time options. You don't really have options for this anyway.
  if timeIndex.ItemIndex < 2 then
  begin
    startTime.Enabled := False;
    endTime.Enabled := False;
    endTime.EditLabel.Caption := 'End Time(Epoch Seconds)';
  end;
end;

procedure TRPCForm.FormWindowStateChange(Sender: TObject);
begin
  if RPCForm.WindowState = wsMinimized then
  begin
    self.Hide;
    TrayIcon.ShowBalloonHint;
     end;
end;

procedure TRPCForm.LoadProfileClick(Sender: TObject);
var
  Settings: TINIFile;
begin
  if OpenINI.Execute then
  begin
    Settings := TINIFile.Create(OpenINI.FileName);
    try
      ApplicationID.Text := Settings.ReadString('MAIN', 'AppID', '');
      state.Text := Settings.ReadString('STATUS', 'state', '');
      details.Text := Settings.ReadString('STATUS', 'details', '');
      smallImageKey.Text := Settings.ReadString('IMAGE', 'smallImageKey', '');
      largeImageKey.Text := Settings.ReadString('IMAGE', 'largeImageKey', '');
      smallImageText.Text := Settings.ReadString('IMAGE', 'smallImageText', '');
      largeImageText.Text := Settings.ReadString('IMAGE', 'largeImageText', '');
      partySize.Text := Settings.ReadString('PARTY', 'partySize', '0');
      partyMax.Text := Settings.ReadString('PARTY', 'partyMax', '0');
      startTime.Text := Settings.ReadString('TIME', 'startTime', '0');
      endTime.Text := Settings.ReadString('TIME', 'endTime', '0');
      timeIndex.ItemIndex := StrToInt(Settings.ReadString('TIME', 'timeIndex', '0'));
    finally
      Settings.Free;
    end;
  end;
  if timeIndex.ItemIndex = 3 then
  begin
    startTime.Enabled := True;
    endTime.Enabled := True;
    endTime.EditLabel.Caption := 'End Time(Epoch Seconds)';
  end;
  if timeIndex.ItemIndex = 2 then
  begin
    startTime.Enabled := False;
    endTime.Enabled := True;
    endTime.EditLabel.Caption := 'Timer(In Seconds)';
  end;
  //Disable time options. You don't really have options for this anyway.
  if timeIndex.ItemIndex < 2 then
  begin
    startTime.Enabled := False;
    endTime.Enabled := False;
    endTime.EditLabel.Caption := 'End Time(Epoch Seconds)';
  end;
end;

procedure TRPCForm.MenuAboutClick(Sender: TObject);
begin
  ShowMessage(
  'Version ' + Version + LineEnding +
  'PascalRPC is an application created in an IDE called Lazarus and surely without surprise, written in the pascal programming language.'
  + LineEnding + LineEnding +
     'Created by Commando950.'
  );
end;

procedure TRPCForm.MenuHowToUseClick(Sender: TObject);
var
  nextpara: String;
begin
  nextpara := LineEnding + LineEnding;
      ShowMessage(
     'Usage of PascalRPC is simple. Enter in your Application ID which is located on your Discord applications page. If you have not made an application yet you need to visit https://discordapp.com/developers/applications/ and create one.' + nextpara +
  'Upon creating an application on the official Discord site you will see "Client ID". Copy the client ID into the applications box, make sure you are on discord, at minimum set your status or something, and then click ENABLE RPC button. You should notice in discord now you have a custom status.' + nextpara +
  'Be sure to hover your mouse over various names and a hint will appear telling you more about the options in this program.' + nextpara +
  'I hope you enjoy using the program! Have fun!'
  );
end;

procedure TRPCForm.MenuLoadProfileClick(Sender: TObject);
var
  Settings: TINIFile;
begin
  if OpenINI.Execute then
  begin
    Settings := TINIFile.Create(OpenINI.FileName);
    try
      ApplicationID.Text := Settings.ReadString('MAIN', 'AppID', '');
      state.Text := Settings.ReadString('STATUS', 'state', '');
      details.Text := Settings.ReadString('STATUS', 'details', '');
      smallImageKey.Text := Settings.ReadString('IMAGE', 'smallImageKey', '');
      largeImageKey.Text := Settings.ReadString('IMAGE', 'largeImageKey', '');
      smallImageText.Text := Settings.ReadString('IMAGE', 'smallImageText', '');
      largeImageText.Text := Settings.ReadString('IMAGE', 'largeImageText', '');
      partySize.Text := Settings.ReadString('PARTY', 'partySize', '0');
      partyMax.Text := Settings.ReadString('PARTY', 'partyMax', '0');
      startTime.Text := Settings.ReadString('TIME', 'startTime', '0');
      endTime.Text := Settings.ReadString('TIME', 'endTime', '0');
      timeIndex.ItemIndex := StrToInt(Settings.ReadString('TIME', 'timeIndex', '0'));
    finally
      Settings.Free;
    end;
  end;
end;

procedure TRPCForm.MenuSaveProfileClick(Sender: TObject);
var
  Settings: TINIFile;
begin
  if SaveINI.Execute then
  begin
    Settings := TINIFile.Create(SaveINI.FileName);
    try
      Settings.WriteString('MAIN', 'AppID', ApplicationID.Text);
      Settings.WriteString('STATUS', 'state', state.Text);
      Settings.WriteString('STATUS', 'details', details.Text);
      Settings.WriteString('IMAGE', 'smallImageKey', smallImageKey.Text);
      Settings.WriteString('IMAGE', 'largeImageKey', largeImageKey.Text);
      Settings.WriteString('IMAGE', 'smallImageText', smallImageText.Text);
      Settings.WriteString('IMAGE', 'largeImageText', largeImageText.Text);
      Settings.WriteString('PARTY', 'partySize', partySize.Text);
      Settings.WriteString('PARTY', 'partyMax', partyMax.Text);
      Settings.WriteString('TIME', 'startTime', startTime.Text);
      Settings.WriteString('TIME', 'endTime', endTime.Text);
      Settings.WriteString('TIME', 'timeIndex', IntToStr(timeIndex.ItemIndex));
    finally
      Settings.Free;
    end;
  end;
end;

procedure TRPCForm.TrayMenuCloseClick(Sender: TObject);
begin
  self.Close;
end;

procedure TRPCForm.TrayMenuOpenClick(Sender: TObject);
begin
  self.Show;
  self.WindowState := wsNormal;
end;

procedure TRPCForm.SaveProfileClick(Sender: TObject);
var
  Settings: TINIFile;
begin
  if SaveINI.Execute then
  begin
    Settings := TINIFile.Create(SaveINI.FileName);
    try
      Settings.WriteString('MAIN', 'AppID', ApplicationID.Text);
      Settings.WriteString('STATUS', 'state', state.Text);
      Settings.WriteString('STATUS', 'details', details.Text);
      Settings.WriteString('IMAGE', 'smallImageKey', smallImageKey.Text);
      Settings.WriteString('IMAGE', 'largeImageKey', largeImageKey.Text);
      Settings.WriteString('IMAGE', 'smallImageText', smallImageText.Text);
      Settings.WriteString('IMAGE', 'largeImageText', largeImageText.Text);
      Settings.WriteString('PARTY', 'partySize', partySize.Text);
      Settings.WriteString('PARTY', 'partyMax', partyMax.Text);
      Settings.WriteString('TIME', 'startTime', startTime.Text);
      Settings.WriteString('TIME', 'endTime', endTime.Text);
      Settings.WriteString('TIME', 'timeIndex', IntToStr(timeIndex.ItemIndex));
    finally
      Settings.Free;
    end;
  end;
end;

procedure UpdateRPC();
var
  PresenceData: DiscordRPC.DiscordRichPresence;
begin
  if Length(RPCForm.state.Text) = 1 then
    PresenceData.state := RPCForm.state.Text + ' '
  else
    PresenceData.state := RPCForm.state.Text;
  if Length(RPCForm.details.Text) = 1 then
    PresenceData.details := RPCForm.details.Text + ' '
  else
    PresenceData.details := RPCForm.details.Text;
  PresenceData.smallImageKey := RPCForm.smallImageKey.Text;
  PresenceData.largeImageKey := RPCForm.largeImageKey.Text;
  PresenceData.smallImageText := RPCForm.smallImageText.Text;
  PresenceData.largeImageText := RPCForm.largeImageText.Text;
  PresenceData.partySize := StrToInt(RPCForm.partySize.Text);
  PresenceData.partyMax := StrToInt(RPCForm.partyMax.Text);
  //Don't show time.
  if RPCForm.timeIndex.ItemIndex = 0 then
  begin
    PresenceData.startTimestamp := 0;
    PresenceData.endTimeStamp := 0;
  end;
  //Use the current time.
  if RPCForm.timeIndex.ItemIndex = 1 then
  begin
    PresenceData.startTimestamp := DateTimeToUnix(LocalTimeToUniversal(Now() - Time()));
    PresenceData.endTimeStamp := 0;
  end;
  //Set a timer from now.
  if RPCForm.timeIndex.ItemIndex = 2 then
  begin
    PresenceData.startTimestamp := 0;
    PresenceData.endTimeStamp := DateTimeToUnix(LocalTimeToUniversal(Now())) +
      StrToInt(RPCForm.endTime.Text);
  end;
  //Set the exact time yourself.
  if RPCForm.timeIndex.ItemIndex = 3 then
  begin
    PresenceData.startTimestamp := StrToInt(RPCForm.startTime.Text);
    PresenceData.endTimeStamp := StrToInt(RPCForm.endTime.Text);
  end;
  DiscordRPC.Discord_UpdatePresence(PresenceData);
  //Start counting up from the current time.
  if RPCForm.timeIndex.ItemIndex = 4 then
  begin
    PresenceData.startTimestamp := DateTimeToUnix(LocalTimeToUniversal(Now()));
    PresenceData.endTimeStamp := 0;
  end;
  DiscordRPC.Discord_UpdatePresence(PresenceData);
end;

procedure TRPCForm.EnableRPCClick(Sender: TObject);
begin
  if not RPCActive then
  begin
    if Length(ApplicationID.Text) < 18 then
    begin
      ShowMessage('Please enter a valid application ID.');
      Exit;
          end;
    DiscordRPC.Discord_Initialize(ApplicationID.Text, nil, 0);
    EnableRPC.Caption := 'Update Status';
    RPCActive := True;
    ShutdownRPC.Enabled := True;
  end;
  UpdateRPC();
end;

procedure TRPCForm.ShutdownRPCClick(Sender: TObject);
begin
  if RPCActive then
  begin
    RPCActive := False;
    DiscordRPC.Discord_Shutdown();
    EnableRPC.Caption := 'Enable RPC';
    ShutdownRPC.Enabled := False;
  end;
end;

procedure TRPCForm.partyMaxChange(Sender: TObject);
begin
  if partyMax.Text = '' then
    partyMax.Text := '0';
end;

procedure TRPCForm.partyMaxKeyPress(Sender: TObject; var Key: char);
begin
  if not (Key in ['0'..'9', #8]) then
    Key := #0;
end;

procedure TRPCForm.partySizeChange(Sender: TObject);
begin
  if partySize.Text = '' then
    partySize.Text := '0';
end;

procedure TRPCForm.partySizeKeyPress(Sender: TObject; var Key: char);
begin
  if not (Key in ['0'..'9', #8]) then
    Key := #0;
end;

procedure TRPCForm.endTimeChange(Sender: TObject);
begin
  if endTime.Text = '' then
    endTime.Text := '0';
end;

procedure TRPCForm.endTimeKeyPress(Sender: TObject; var Key: char);
begin
  if not (Key in ['0'..'9', #8]) then
    Key := #0;
end;

procedure TRPCForm.startTimeChange(Sender: TObject);
begin
  if startTime.Text = '' then
    startTime.Text := '0';
end;

procedure TRPCForm.startTimeKeyPress(Sender: TObject; var Key: char);
begin
  if not (Key in ['0'..'9', #8]) then
    Key := #0;
end;

procedure TRPCForm.timeIndexChange(Sender: TObject);
begin
  if timeIndex.ItemIndex = 4 then
  begin
    startTime.Enabled := False;
    endTime.Enabled := False;
    endTime.EditLabel.Caption := 'End Time(Epoch Seconds)';
  end;
  if timeIndex.ItemIndex = 3 then
  begin
    startTime.Enabled := True;
    endTime.Enabled := True;
    endTime.EditLabel.Caption := 'End Time(Epoch Seconds)';
  end;
  if timeIndex.ItemIndex = 2 then
  begin
    startTime.Enabled := False;
    endTime.Enabled := True;
    endTime.EditLabel.Caption := 'Timer(In Seconds)';
  end;
  //Disable time options. You don't really have options for this anyway.
  if timeIndex.ItemIndex < 2 then
  begin
    startTime.Enabled := False;
    endTime.Enabled := False;
    endTime.EditLabel.Caption := 'End Time(Epoch Seconds)';
  end;
end;

procedure TRPCForm.TrayIconClick(Sender: TObject);
begin
  self.Show;
  self.WindowState := wsNormal;
end;

end.
