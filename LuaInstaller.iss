[Setup]
AppName=Lua
AppVersion=5.1.5
DefaultDirName={pf}\Lua
DefaultGroupName=Lua
UninstallDisplayIcon={app}\lua.exe
Compression=lzma2/ultra64
SolidCompression=yes
AppId={{DDEF061B-4163-4050-A3EC-9D3208E9939D}
AppPublisher=Xpol Wan
AppPublisherURL=https://github.com/xpol
AppSupportURL=https://github.com/xpol/luainstaller/issues
AppUpdatesURL=https://github.com/xpol/luainstaller/releases
InternalCompressLevel=ultra64
MinVersion=0,6.1

[Files]
Source: "config.lua"; DestDir: "{app}"; DestName: "config.lua"
Source: "lua*.exe"; DestDir: "{app}"
Source: "lua*.dll"; DestDir: "{app}"
Source: "lua*.lib"; DestDir: "{app}"
Source: "luarocks"; DestDir: "{app}"; DestName: "luarocks"
Source: "luarocks-admin"; DestDir: "{app}"; DestName: "luarocks-admin"
Source: "luarocks-admin.bat"; DestDir: "{app}"; DestName: "luarocks-admin.bat"
Source: "luarocks.bat"; DestDir: "{app}"; DestName: "luarocks.bat"
Source: "setup"; DestDir: "{app}"; DestName: "setup"
Source: "setup.cmd"; DestDir: "{app}"; DestName: "setup.cmd"
Source: "doc\*"; DestDir: "{app}\doc"; Flags: recursesubdirs
Source: "include\*"; DestDir: "{app}\include"; Flags: recursesubdirs
Source: "lua\*"; DestDir: "{app}\lua"; Flags: recursesubdirs
Source: "tools\*"; DestDir: "{app}\tools"; Flags: recursesubdirs

[Dirs]
Name: "{app}\cmod"
Name: "{app}\rocks"

[Run]
Filename: "setup.cmd"; WorkingDir: "{app}"; Flags: runhidden

[UninstallDelete]
Type: files; Name: "{app}\*.bat"
Type: dirifempty; Name: "{app}"
