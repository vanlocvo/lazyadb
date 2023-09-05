;--------------------------------
;Include Modern UI

    !include "MUI2.nsh"

;--------------------------------
;General

    ;Name and file
    Name "LazyADB"
    OutFile "build\LazyADB.exe"
    ShowInstDetails Show
    Unicode True

    !define MUI_ICON "assets\icon.ico"
    !define MUI_UNICON "assets\icon.ico"
    !define MUI_HEADERIMAGE
    !define MUI_HEADERIMAGE_BITMAP "assets\logo.bmp"
    !define MUI_HEADERIMAGE_BITMAP_NOSTRETCH
    !define MUI_HEADERIMAGE_RIGHT

    ;Default installation folder
    InstallDir "$LOCALAPPDATA\LazyADB"
    
    ;Get installation folder from registry if available
    InstallDirRegKey HKCU "Software\LazyADB" ""

    RequestExecutionLevel user

    BrandingText "LazyADB Installer"
;--------------------------------
;Interface Settings

    !define MUI_ABORTWARNING

;--------------------------------
;Pages
    !insertmacro MUI_PAGE_DIRECTORY
    !insertmacro MUI_PAGE_INSTFILES
    
    !insertmacro MUI_UNPAGE_CONFIRM
    !insertmacro MUI_UNPAGE_INSTFILES
  
;--------------------------------
;Languages
 
    !insertmacro MUI_LANGUAGE "English"
    LangString nsisunz_text ${LANG_ENGLISH} "Extract: %f (%c -> %b) [%p]"

;--------------------------------
;Installer Sections

Section "Installer"
    InitPluginsDir
    SetOutpath "$INSTDIR"

    nsProcessW::_FindProcess "adb.exe"
    Pop $R0
    ${If} $R0 == 0
      MessageBox MB_OK|MB_ICONEXCLAMATION "adb is running. Please close it first" /SD IDOK
      DetailPrint "Aborted"
      Abort
    ${EndIf}

    NSISdl::download "https://dl.google.com/android/repository/platform-tools-latest-windows.zip" "$INSTDIR\platform-tools-latest-windows.zip"  /END    
    
    Pop $0
    ${If} $0 == "success"
    ${Else}
        MessageBox mb_iconstop "Download failed: $0"
        DetailPrint "Aborted"
        Abort
    ${EndIf}

    nsisunz::UnzipToLog "$INSTDIR\platform-tools-latest-windows.zip" "$INSTDIR"
    ; Always check result on stack
    Pop $0
    ${If} $0 == "success"
    ${Else}
        MessageBox mb_iconstop "Extract failed: $0" 
        Delete "platform-tools-latest-windows.zip"
        DetailPrint "Aborted"
        Abort
    ${EndIf}

    Delete "platform-tools-latest-windows.zip"

    ;--------------
    ; ADD PATH
    EnVar::SetHKCU

    EnVar::AddValueEx "path" "$INSTDIR\platform-tools"

    ;Store installation folder
    WriteRegStr HKCU "Software\LazyADB" "" $INSTDIR
    
    ;Create uninstaller
    WriteUninstaller "$INSTDIR\Uninstaller.exe"

    ;Add uninstall information to Add/Remove Programs
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\LazyADB"  "DisplayName" "LazyADB"
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\LazyADB"  "UninstallString" "$\"$INSTDIR\Uninstaller.exe$\""

SectionEnd


;--------------------------------
;Uninstaller Section

Section "Uninstall"

    nsProcessW::_FindProcess "adb.exe"
    Pop $R0
    ${If} $R0 == 0
      MessageBox MB_OK|MB_ICONEXCLAMATION "adb is running. Please close it first" /SD IDOK
      DetailPrint "Aborted"
      Abort
    ${EndIf}

    ;--------------
    ; REMOVE PATH
    ; Check if the path entry already exists and write result to $0
    EnVar::SetHKCU

    EnVar::DeleteValue "path" "$INSTDIR\platform-tools"

    Delete "$INSTDIR\*.*"

    Delete "$INSTDIR\Uninstaller.exe"

    RMDir /r "$INSTDIR"

    DeleteRegKey HKCU "Software\LazyADB"
    DeleteRegKey HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\LazyADB"

SectionEnd