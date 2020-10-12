unit DiscordRPC;

{$mode objfpc}{$H+}

interface

type

  DiscordRichPresence = packed record
    state: AnsiString;
    details: AnsiString;
    startTimestamp: Int64;
    endTimestamp: Int64;
    largeImageKey: AnsiString;
    largeImageText: AnsiString;
    smallImageKey: AnsiString;
    smallImageText: AnsiString;
    partyId: AnsiString;
    partySize: Integer;
    partyMax: Integer;
    matchSecret: AnsiString;
    joinSecret: AnsiString;
    spectateSecret: AnsiString;
    instance: Shortint;
  end;

  PTRDiscordRichPresence = ^DiscordRichPresence;

  DiscordUser = packed record
    userID: AnsiString;
    username: AnsiString;
    discriminator: AnsiString;
    avatar: AnsiString;
  end;

  DiscordEventHandlers = packed record
    ready: pointer;
    disconnected: pointer;
    errored: pointer;
    joinGame: pointer;
    spectateGame: pointer;
    joinRequest: pointer;
  end;
{$IFDEF CPU64}
  {$IFDEF Windows}
    procedure Discord_Initialize(applicationId: AnsiString;
      EventHandlers: DiscordEventHandlers; autoRegister: longint); cdecl;
      external 'discord-rpc.dll';
    procedure Discord_Initialize(applicationId: AnsiString;
      EventHandlers: Pointer; autoRegister: longint); cdecl;
      external 'discord-rpc.dll';
    procedure Discord_Initialize(applicationId: AnsiString;
      EventHandlers: DiscordEventHandlers; autoRegister: longint;optionalSteamId:AnsiString); cdecl;
      external 'discord-rpc.dll';
    procedure Discord_Shutdown(); cdecl; external 'discord-rpc.dll';
    procedure Discord_UpdateConnection(); cdecl; external 'discord-rpc.dll';
    procedure Discord_UpdatePresence(PresenceData: PTRDiscordRichPresence);
      cdecl; external 'discord-rpc.dll';
    procedure Discord_ClearPresence(); cdecl; external 'discord-rpc.dll';
    procedure Discord_Respond(userid: AnsiString; reply: longint);
      cdecl; external 'discord-rpc.dll';
    procedure Discord_UpdateHandlers(EventHandlers: DiscordEventHandlers);
      cdecl; external 'discord-rpc.dll';
  {$ELSE}
    {$IFDEF Linux}
      procedure Discord_Initialize(applicationId: AnsiString;
        EventHandlers: DiscordEventHandlers; autoRegister: longint); cdecl;
        external 'libdiscord-rpc.so';
      procedure Discord_Initialize(applicationId: AnsiString;
        EventHandlers: Pointer; autoRegister: longint); cdecl;
        external 'libdiscord-rpc.so';
      procedure Discord_Initialize(applicationId: AnsiString;
        EventHandlers: DiscordEventHandlers; autoRegister: longint;optionalSteamId:AnsiString); cdecl;
        external 'libdiscord-rpc.so';
      procedure Discord_Shutdown(); cdecl; external 'libdiscord-rpc.so';
      procedure Discord_UpdateConnection(); cdecl; external 'libdiscord-rpc.so';
      procedure Discord_UpdatePresence(PresenceData: PTRDiscordRichPresence);
        cdecl; external 'libdiscord-rpc.so';
      procedure Discord_ClearPresence(); cdecl; external 'libdiscord-rpc.so';
      procedure Discord_Respond(userid: AnsiString; reply: longint);
        cdecl; external 'libdiscord-rpc.so';
      procedure Discord_UpdateHandlers(EventHandlers: DiscordEventHandlers);
        cdecl; external 'libdiscord-rpc.so';
    {$ELSE}
      {$error Compilation not yet supported! Can you help add this?}
    {$ENDIF}
  {$ENDIF}
{$ENDIF}
{$IFDEF CPU32}
  {$IFDEF Windows}
    procedure Discord_Initialize(applicationId: AnsiString;
      EventHandlers: DiscordEventHandlers; autoRegister: longint); cdecl;
      external 'discord-rpc32.dll';
    procedure Discord_Initialize(applicationId: AnsiString;
      EventHandlers: Pointer; autoRegister: longint); cdecl;
      external 'discord-rpc32.dll';
    procedure Discord_Initialize(applicationId: AnsiString;
      EventHandlers: DiscordEventHandlers; autoRegister: longint;optionalSteamId:AnsiString); cdecl;
      external 'discord-rpc32.dll';
    procedure Discord_Shutdown(); cdecl; external 'discord-rpc32.dll';
    procedure Discord_UpdateConnection(); cdecl; external 'discord-rpc32.dll';
    procedure Discord_UpdatePresence(PresenceData: PTRDiscordRichPresence);
      cdecl; external 'discord-rpc32.dll';
    procedure Discord_ClearPresence(); cdecl; external 'discord-rpc32.dll';
    procedure Discord_Respond(userid: AnsiString; reply: longint);
      cdecl; external 'discord-rpc32.dll';
    procedure Discord_UpdateHandlers(EventHandlers: DiscordEventHandlers);
      cdecl; external 'discord-rpc32.dll';
  {$ELSE}
    {$error 32 Bit compilation not yet supported on systems other than Windows!}
  {$ENDIF}
{$ENDIF}

const
  DISCORD_REPLY_NO = 0;
  DISCORD_REPLY_YES = 1;
  DISCORD_REPLY_IGNORE = 2;

implementation


end.
