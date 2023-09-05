;--------------------------------
;Include Modern UI

    !include "MUI2.nsh"

;--------------------------------
;General

    ;Name and file
    Name "LazyADB"
    OutFile "LazyADB.exe"
    ShowInstDetails Show
    Unicode True

    !define MUI_ICON "icon\icon.ico"
    !define MUI_HEADERIMAGE
    !define MUI_HEADERIMAGE_BITMAP "icon\icon.png"
    !define MUI_HEADERIMAGE_RIGHT

    ;Default installation folder
    InstallDir "$LOCALAPPDATA\LazyADB"
    
    ;Get installation folder from registry if available
    InstallDirRegKey HKCU "Software\LazyADB" ""

    RequestExecutionLevel user

;--------------------------------
;Interface Settings

    !define MUI_ABORTWARNING

;--------------------------------
;Pages

    ; !insertmacro MUI_PAGE_LICENSE "${NSISDIR}\Docs\Modern UI\License.txt"
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

Section 
    InitPluginsDir
    SetOutpath "$INSTDIR"
    inetc::get  "https://dl.google.com/android/repository/platform-tools-latest-windows.zip" "platform-tools-latest-windows.zip"  /END    
    
    Pop $0
    ${If} $0 == "OK"
    ${Else}
        MessageBox mb_iconstop "Download fail: $0" 
        Quit
    ${EndIf}


    File "unzip.exe"
    nsExec::ExecToLog 'unzip.exe -o "$INSTDIR\platform-tools-latest-windows.zip" -x platform-tools/systrace*' 

    Delete "platform-tools-latest-windows.zip"
    Delete "unzip.exe"

    ;--------------
    ; ADD PATH
    EnVar::SetHKCU

    EnVar::AddValueEx "path" "$INSTDIR\platform-tools"

 

    ;Store installation folder
    WriteRegStr HKCU "Software\LazyADB" "" $INSTDIR
    
    ;Create uninstaller
    WriteUninstaller "$INSTDIR\Uninstall.exe"

SectionEnd


;--------------------------------
;Uninstaller Section

Section "Uninstall"

    ;--------------
    ; REMOVE PATH
    ; Check if the path entry already exists and write result to $0
    EnVar::SetHKCU

    EnVar::DeleteValue "path" "$INSTDIR\platform-tools"


    Delete "$INSTDIR\*.*"

    Delete "$INSTDIR\Uninstall.exe"

    RMDir /r "$INSTDIR"

    DeleteRegKey /ifempty HKCU "Software\LazyADB"

SectionEnd