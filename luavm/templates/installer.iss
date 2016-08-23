[Setup]
AppName=LuaVM
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
Name: "JIT20"; Description: "The LuaJIT 2.0 with LuaRocks"; Types: full
Name: "JIT21"; Description: "The LuaJIT 2.1 with LuaRocks"; Types: full; Flags: fixed

[Dirs]
Name: "{app}\luavm\versions"; Permissions: users-full
Components: Lua51; Permissions: users-full; Name: "{app}\luavm\versions\5.1"
Components: Lua51; Permissions: users-full; Name: "{app}\luavm\versions\5.1\cmod"
Components: Lua51; Permissions: users-full; Name: "{app}\luavm\versions\5.1\rocks"

Components: Lua52; Permissions: users-full; Name: "{app}\luavm\versions\5.2"
Components: Lua52; Permissions: users-full; Name: "{app}\luavm\versions\5.2\cmod"
Components: Lua52; Permissions: users-full; Name: "{app}\luavm\versions\5.2\rocks"

Components: Lua53; Permissions: users-full; Name: "{app}\luavm\versions\5.3"
Components: Lua53; Permissions: users-full; Name: "{app}\luavm\versions\5.3\cmod"
Components: Lua53; Permissions: users-full; Name: "{app}\luavm\versions\5.3\rocks"

Components: JIT20; Permissions: users-full; Name: "{app}\luavm\versions\luajit-2.0"
Components: JIT20; Permissions: users-full; Name: "{app}\luavm\versions\luajit-2.0\cmod"
Components: JIT20; Permissions: users-full; Name: "{app}\luavm\versions\luajit-2.0\rocks"

Components: JIT21; Permissions: users-full; Name: "{app}\luavm\versions\luajit-2.1"
Components: JIT21; Permissions: users-full; Name: "{app}\luavm\versions\luajit-2.1\cmod"
Components: JIT21; Permissions: users-full; Name: "{app}\luavm\versions\luajit-2.1\rocks"

[Files]
Source: "luavm\*"; DestDir: "{app}\luavm"; Flags: ignoreversion recursesubdirs

Components: Lua51; Permissions: users-full; Source: "versions\5.1\*"; DestDir: "{app}\luavm\versions\5.1"; Flags: ignoreversion recursesubdirs
Components: Lua51; Permissions: users-full; Source: "versions\5.1\luarocks.bat"; DestDir: "{app}\luavm\versions\5.1"; DestName: luarocks-admin.bat
Components: Lua51; Permissions: users-full; Source: "@PROJECT_SOURCE_DIR@\lua\versions\lua-5.1\doc\*"; DestDir: "{app}\luavm\versions\5.1\doc"; Flags: recursesubdirs
Components: Lua51; Permissions: users-full; Source: "@PROJECT_SOURCE_DIR@\luarocks\win32\tools\*"; DestDir: "{app}\luavm\versions\5.1\tools"; Flags: ignoreversion recursesubdirs
Components: Lua51; Permissions: users-full; Source: "@PROJECT_SOURCE_DIR@\luarocks\src\luarocks\*"; DestDir: "{app}\luavm\versions\5.1\lua\luarocks"; Flags: recursesubdirs
Components: Lua51; Permissions: users-full; Source: "@PROJECT_SOURCE_DIR@\luarocks\src\bin\*"; DestDir: "{app}\luavm\versions\5.1"


Components: Lua52; Permissions: users-full; Source: "versions\5.2\*"; DestDir: "{app}\luavm\versions\5.2"; Flags: ignoreversion recursesubdirs
Components: Lua52; Permissions: users-full; Source: "versions\5.2\luarocks.bat"; DestDir: "{app}\luavm\versions\5.2"; DestName: luarocks-admin.bat
Components: Lua52; Permissions: users-full; Source: "@PROJECT_SOURCE_DIR@\lua\versions\lua-5.2\doc\*"; DestDir: "{app}\luavm\versions\5.2\doc"; Flags: recursesubdirs
Components: Lua52; Permissions: users-full; Source: "@PROJECT_SOURCE_DIR@\luarocks\win32\tools\*"; DestDir: "{app}\luavm\versions\5.2\tools"; Flags: ignoreversion recursesubdirs
Components: Lua52; Permissions: users-full; Source: "@PROJECT_SOURCE_DIR@\luarocks\src\luarocks\*"; DestDir: "{app}\luavm\versions\5.2\lua\luarocks"; Flags: recursesubdirs
Components: Lua52; Permissions: users-full; Source: "@PROJECT_SOURCE_DIR@\luarocks\src\bin\*"; DestDir: "{app}\luavm\versions\5.2"


Components: Lua53; Permissions: users-full; Source: "versions\5.3\*"; DestDir: "{app}\luavm\versions\5.3"; Flags: ignoreversion recursesubdirs
Components: Lua53; Permissions: users-full; Source: "versions\5.3\luarocks.bat"; DestDir: "{app}\luavm\versions\5.3"; DestName: luarocks-admin.bat
Components: Lua53; Permissions: users-full; Source: "@PROJECT_SOURCE_DIR@\lua\versions\lua-5.3\doc\*"; DestDir: "{app}\luavm\versions\5.3\doc"; Flags: recursesubdirs
Components: Lua53; Permissions: users-full; Source: "@PROJECT_SOURCE_DIR@\luarocks\win32\tools\*"; DestDir: "{app}\luavm\versions\5.3\tools"; Flags: ignoreversion recursesubdirs
Components: Lua53; Permissions: users-full; Source: "@PROJECT_SOURCE_DIR@\luarocks\src\luarocks\*"; DestDir: "{app}\luavm\versions\5.3\lua\luarocks"; Flags: recursesubdirs
Components: Lua53; Permissions: users-full; Source: "@PROJECT_SOURCE_DIR@\luarocks\src\bin\*"; DestDir: "{app}\luavm\versions\5.3"

Components: JIT20; Permissions: users-full; Source: "versions\luajit-2.0\*"; DestDir: "{app}\luavm\versions\luajit-2.0"; Flags: ignoreversion recursesubdirs
Components: JIT20; Permissions: users-full; Source: "versions\luajit-2.0\luarocks.bat"; DestDir: "{app}\luavm\versions\luajit-2.0"; DestName: luarocks-admin.bat
Components: JIT20; Permissions: users-full; Source: "@PROJECT_SOURCE_DIR@\lua\versions\luajit-2.0\doc\*"; DestDir: "{app}\luavm\versions\luajit-2.0\doc"; Flags: recursesubdirs
Components: JIT20; Permissions: users-full; Source: "@PROJECT_SOURCE_DIR@\luarocks\win32\tools\*"; DestDir: "{app}\luavm\versions\luajit-2.0\tools"; Flags: ignoreversion recursesubdirs
Components: JIT20; Permissions: users-full; Source: "@PROJECT_SOURCE_DIR@\luarocks\src\luarocks\*"; DestDir: "{app}\luavm\versions\luajit-2.0\lua\luarocks"; Flags: recursesubdirs
Components: JIT20; Permissions: users-full; Source: "@PROJECT_SOURCE_DIR@\luarocks\src\bin\*"; DestDir: "{app}\luavm\versions\luajit-2.0"

Components: JIT21; Permissions: users-full; Source: "versions\luajit-2.1\*"; DestDir: "{app}\luavm\versions\luajit-2.1"; Flags: ignoreversion recursesubdirs
Components: JIT21; Permissions: users-full; Source: "versions\luajit-2.1\luarocks.bat"; DestDir: "{app}\luavm\versions\luajit-2.1"; DestName: luarocks-admin.bat
Components: JIT21; Permissions: users-full; Source: "@PROJECT_SOURCE_DIR@\lua\versions\luajit-2.1\doc\*"; DestDir: "{app}\luavm\versions\luajit-2.1\doc"; Flags: recursesubdirs
Components: JIT21; Permissions: users-full; Source: "@PROJECT_SOURCE_DIR@\luarocks\win32\tools\*"; DestDir: "{app}\luavm\versions\luajit-2.1\tools"; Flags: ignoreversion recursesubdirs
Components: JIT21; Permissions: users-full; Source: "@PROJECT_SOURCE_DIR@\luarocks\src\luarocks\*"; DestDir: "{app}\luavm\versions\luajit-2.1\lua\luarocks"; Flags: recursesubdirs
Components: JIT21; Permissions: users-full; Source: "@PROJECT_SOURCE_DIR@\luarocks\src\bin\*"; DestDir: "{app}\luavm\versions\luajit-2.1"

[Run]
Filename: "{app}\luavm\luavm.cmd"; Parameters: "migrate install"; Flags: runhidden
Filename: "{app}\luavm\luavm.cmd"; Parameters: "use luajit-2.1"; Flags: runhidden

[UninstallRun]
Filename: "{app}\luavm\luavm.cmd"; Parameters: "migrate remove"; Flags: runhidden

[UninstallDelete]
Type: filesandordirs; Name: "{app}\luavm\versions"
Type: filesandordirs; Name: "{app}\luavm"
Type: filesandordirs; Name: "{app}"
