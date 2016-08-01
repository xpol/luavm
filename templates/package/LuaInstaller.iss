[Setup]
AppName=LuaInstaller
AppVersion=0.1.0
DefaultDirName={@INNO_PF@}\Lua
UsePreviousAppDir=False
DefaultGroupName=Lua
Compression=lzma2/ultra64
SolidCompression=yes
AppId={{DDEF061B-4163-4050-A3EC-9D3208E9939D}
AppPublisher=Xpol Wan
AppPublisherURL=https://github.com/xpol
AppSupportURL=https://github.com/xpol/luainstaller/issues
AppUpdatesURL=https://github.com/xpol/luainstaller/releases
InternalCompressLevel=ultra64
MinVersion=0,6.1
ArchitecturesInstallIn64BitMode=x64

[Components]
Name: "Lua51"; Description: "The Lua 5.1 with LuaRocks"; Types: full
Name: "Lua52"; Description: "The Lua 5.2 with LuaRocks"; Types: full
Name: "Lua53"; Description: "The Lua 5.3 with LuaRocks"; Types: full
Name: "LuaJIT20"; Description: "The LuaJIT 2.0 with LuaRocks"; Types: full
Name: "LuaJIT21"; Description: "The LuaJIT 2.1 with LuaRocks"; Types: full; Flags: checkablealone

[Dirs]
Name: "{app}\versions"; Permissions: users-full
Name: "{app}\versions\5.1"; Components: Lua51; Permissions: users-full
Name: "{app}\versions\5.2"; Components: Lua52; Permissions: users-full
Name: "{app}\versions\5.3"; Components: Lua53; Permissions: users-full
Name: "{app}\versions\luajit-2.0"; Components: LuaJIT20; Permissions: users-full
Name: "{app}\versions\luajit-2.1"; Components: LuaJIT21; Permissions: users-full

[Files]
Source: "versions\5.1\*"; DestDir: "{app}\versions\5.1"; Flags: ignoreversion recursesubdirs; Components: Lua51; Permissions: users-full
Source: "versions\5.2\*"; DestDir: "{app}\versions\5.2"; Flags: ignoreversion recursesubdirs; Components: Lua52; Permissions: users-full
Source: "versions\5.3\*"; DestDir: "{app}\versions\5.3"; Flags: ignoreversion recursesubdirs; Components: Lua53; Permissions: users-full
Source: "versions\luajit-2.0\*"; DestDir: "{app}\versions\luajit-2.0"; Flags: ignoreversion recursesubdirs; Components: LuaJIT20; Permissions: users-full
Source: "versions\luajit-2.1\*"; DestDir: "{app}\versions\luajit-2.1"; Flags: ignoreversion recursesubdirs; Components: LuaJIT21; Permissions: users-full
Source: "luavm\*"; DestDir: "{app}\luavm"; Flags: ignoreversion recursesubdirs

[Code]
function NeedsAddPath(Param: string): boolean;
var
  OrigPath: string;
begin
  if not RegQueryStringValue(HKEY_LOCAL_MACHINE,
    'SYSTEM\CurrentControlSet\Control\Session Manager\Environment',
    'Path', OrigPath)
  then begin
    Result := True;
    exit;
  end;
  // look for the path with leading and trailing semicolon
  // Pos() returns 0 if not found
  Result := Pos(';' + Param + ';', ';' + OrigPath + ';') = 0;
end;

[Registry]
Root: HKLM; Subkey: "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"; ValueType: expandsz; ValueName: "Path"; ValueData: "{olddata};{app}\luavm"; Check: NeedsAddPath('{app}\luavm')

[Run]
Filename: "{app}\luavm\luavm.cmd"; Parameters: "use luajit-2.1"; Flags: runhidden

[UninstallDelete]
Type: filesandordirs; Name: "{app}"
