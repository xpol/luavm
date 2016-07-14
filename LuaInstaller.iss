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
Source: "build\install\config.lua"; DestDir: "{app}"; DestName: "config.lua"
Source: "build\install\lua*.exe"; DestDir: "{app}"
Source: "build\install\lua*.dll"; DestDir: "{app}"
Source: "build\install\lua*.lib"; DestDir: "{app}"
Source: "build\install\luarocks"; DestDir: "{app}"; DestName: "luarocks"
Source: "build\install\luarocks-admin"; DestDir: "{app}"; DestName: "luarocks-admin"
Source: "build\install\luarocks-admin.bat"; DestDir: "{app}"; DestName: "luarocks-admin.bat"
Source: "build\install\luarocks.bat"; DestDir: "{app}"; DestName: "luarocks.bat"
Source: "build\install\setup"; DestDir: "{app}"; DestName: "setup"
Source: "build\install\setup.cmd"; DestDir: "{app}"; DestName: "setup.cmd"
Source: "build\install\doc\*"; DestDir: "{app}\doc"; Flags: recursesubdirs
Source: "build\install\include\*"; DestDir: "{app}\include"; Flags: recursesubdirs
Source: "build\install\lua\*"; DestDir: "{app}\lua"; Flags: recursesubdirs
Source: "build\install\tools\*"; DestDir: "{app}\tools"; Flags: recursesubdirs

[Dirs]
Name: "{app}\cmod"
Name: "{app}\rocks"

[Run]
Filename: "setup.cmd"; WorkingDir: "{app}"; Flags: runhidden

[UninstallDelete]
Type: files; Name: "{app}\*.bat"
Type: dirifempty; Name: "{app}"
