unit DiscordRPC;

{$mode objfpc}{$H+}

interface

type
  DiscordRichPresence = packed record
    state: String;
    details: String;
    startTimestamp: Int64;
    endTimestamp: Int64;
    largeImageKey: String;
    largeImageText: String;
    smallImageKey: String;
    smallImageText: String;
    partyId: String;
    partySize: longint;
    partyMax: longint;
    matchSecret: String;
    joinSecret: String;
    spectateSecret: String;
    instance: shortint;
  end;

  DiscordUser = packed record
    userID: String;
    username: String;
    discriminator: String;
    avatar: String;
  end;

  DiscordEventHandlers = packed record
    ready: pointer;
    disconnected: pointer;
    errored: pointer;
    joinGame: pointer;
    spectateGame: pointer;
    joinRequest: pointer;
  end;

procedure Discord_Initialize(applicationId: String;
  EventHandlers: DiscordEventHandlers; autoRegister: longint); cdecl;
  external 'discord-rpc.dll';
procedure Discord_Initialize(applicationId: String;
  EventHandlers: Pointer; autoRegister: longint); cdecl;
  external 'discord-rpc.dll';
procedure Discord_Initialize(applicationId: String;
  EventHandlers: DiscordEventHandlers; autoRegister: longint;optionalSteamId:PChar); cdecl;
  external 'discord-rpc.dll';
procedure Discord_Shutdown(); cdecl; external 'discord-rpc.dll';
procedure Discord_UpdateConnection(); cdecl; external 'discord-rpc.dll';
procedure Discord_UpdatePresence(PresenceData: DiscordRichPresence);
  cdecl; external 'discord-rpc.dll';
procedure Discord_ClearPresence(); cdecl; external 'discord-rpc.dll';
procedure Discord_Respond(userid: String; reply: longint);
  cdecl; external 'discord-rpc.dll';
procedure Discord_UpdateHandlers(EventHandlers: DiscordEventHandlers);
  cdecl; external 'discord-rpc.dll';

const
  DISCORD_REPLY_NO = 0;
  DISCORD_REPLY_YES = 1;
  DISCORD_REPLY_IGNORE = 2;

implementation


end.
