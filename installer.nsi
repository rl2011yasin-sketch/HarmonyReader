; ======================================================================
; Harmony Reader - Ultra Professional Installer Script
; Publisher: HarmonySoft Inc.
; Version: 1.0
; ======================================================================

!include "MUI2.nsh"
!include "FileFunc.nsh"

; --- General Properties ---
!define APPNAME "Harmony Reader"
!define COMPANYNAME "HarmonySoft Inc."
!define DESCRIPTION "A professional PDF reader and editor."
!define VERSIONMAJOR 1
!define VERSIONMINOR 0
!define VERSIONBUILD 0
!define EXENAME "HarmonyReader.exe"

Name "${APPNAME}"
OutFile "HarmonyReader_Setup_v1.0.exe"
InstallDir "$PROGRAMFILES64\${APPNAME}"
InstallDirRegKey HKLM "Software\${COMPANYNAME}\${APPNAME}" "Install_Dir"
RequestExecutionLevel admin

; --- Icons ---
!define MUI_ICON "app.ico"
!define MUI_UNICON "app.ico"

; --- Modern UI Customization (Removing Nullsoft Branding) ---
!define MUI_ABORTWARNING
BrandingText "${COMPANYNAME} © 2026" ; Removes "Nullsoft Install System" from the bottom
!define MUI_WELCOMEPAGE_TITLE "Welcome to the ${APPNAME} Setup Wizard"
!define MUI_WELCOMEPAGE_TEXT "This wizard will guide you through the installation of ${APPNAME} v1.0.$\r$\n$\r$\n${APPNAME} is a lightweight, professional PDF reader and editor developed by ${COMPANYNAME}.$\r$\n$\r$\nClick Next to continue."

!define MUI_FINISHPAGE_RUN "$INSTDIR\${EXENAME}"
!define MUI_FINISHPAGE_RUN_TEXT "Launch ${APPNAME}"
!define MUI_FINISHPAGE_TITLE "Installation Complete"
!define MUI_FINISHPAGE_TEXT "${APPNAME} has been successfully installed on your computer.$\r$\n$\r$\nClick Finish to close this wizard."

; --- Installer Pages ---
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "License.txt"
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

; --- Uninstaller Pages ---
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

; --- Language (English) ---
!insertmacro MUI_LANGUAGE "English"

; --- Version Information (For Windows File Properties) ---
VIProductVersion "${VERSIONMAJOR}.${VERSIONMINOR}.${VERSIONBUILD}.0"
VIAddVersionKey "ProductName" "${APPNAME}"
VIAddVersionKey "CompanyName" "${COMPANYNAME}"
VIAddVersionKey "LegalCopyright" "© 2026 ${COMPANYNAME}"
VIAddVersionKey "FileDescription" "${DESCRIPTION}"
VIAddVersionKey "FileVersion" "1.0.0.0"
VIAddVersionKey "ProductVersion" "1.0.0.0"

; ======================================================================
; INSTALL SECTION
; ======================================================================
Section "Install" SecMain
    ; Close the application if it's currently running to prevent file lock errors
    nsExec::Exec 'taskkill /F /IM ${EXENAME}'
    Sleep 500

    SetOutPath "$INSTDIR"
    
    ; Copy ALL requested folders and files
    File /r "publish\*.*"
    File /r "bin\*.*"
    File /r "obj\*.*"
    File "app.ico"
    File "License.txt"

    ; --- Create Shortcuts ---
    ; Desktop Shortcut with custom icon
    CreateShortCut "$DESKTOP\${APPNAME}.lnk" "$INSTDIR\${EXENAME}" "" "$INSTDIR\app.ico" 0
    
    ; Start Menu Shortcuts
    CreateDirectory "$SMPROGRAMS\${APPNAME}"
    CreateShortCut "$SMPROGRAMS\${APPNAME}\${APPNAME}.lnk" "$INSTDIR\${EXENAME}" "" "$INSTDIR\app.ico" 0
    CreateShortCut "$SMPROGRAMS\${APPNAME}\Uninstall ${APPNAME}.lnk" "$INSTDIR\uninstall.exe"

    ; --- Write Uninstaller ---
    WriteUninstaller "$INSTDIR\uninstall.exe"

    ; --- Registry Entries (Add/Remove Programs) ---
    ; Using a highly professional registry structure
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayName" "${APPNAME}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayVersion" "1.0.0"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "Publisher" "${COMPANYNAME}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayIcon" "$INSTDIR\app.ico"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "UninstallString" '"$INSTDIR\uninstall.exe"'
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "InstallLocation" "$INSTDIR"
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "NoModify" 1
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "NoRepair" 1
    
    ; Calculate and Write Estimated Size (For Add/Remove Programs)
    ${GetSize} "$INSTDIR" "/S=0K" $0 $1 $2
    IntFmt $0 "0x%08X" $0
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "EstimatedSize" "$0"
    
    ; App Paths (Allows running app from Windows Run dialog)
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\App Paths\${EXENAME}" "" "$INSTDIR\${EXENAME}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\App Paths\${EXENAME}" "Path" "$INSTDIR"
SectionEnd

; ======================================================================
; UNINSTALL SECTION
; ======================================================================
Section "Uninstall"
    ; Close the application if running during uninstall
    nsExec::Exec 'taskkill /F /IM ${EXENAME}'
    Sleep 500

    ; Remove Shortcuts
    Delete "$DESKTOP\${APPNAME}.lnk"
    Delete "$SMPROGRAMS\${APPNAME}\${APPNAME}.lnk"
    Delete "$SMPROGRAMS\${APPNAME}\Uninstall ${APPNAME}.lnk"
    RMDir "$SMPROGRAMS\${APPNAME}"

    ; Remove Files and Directories
    RMDir /r "$INSTDIR"

    ; Remove Registry Keys
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}"
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\App Paths\${EXENAME}"
    DeleteRegKey HKLM "Software\${COMPANYNAME}\${APPNAME}"
SectionEnd