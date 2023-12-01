@echo off
SetLocal EnableDelayedExpansion

rem =============================
rem ====== admin variables ======
rem =============================

set DirName=my_folder
set SourceDir=\\192.168.1.100\Common\Sklad
set BackupDir=\\192.168.1.100\Common\TEXOTDEL\Baboi\backups
set NumFolders=31

rem =============================
rem ======== 7-Zip path =========
rem =============================

set a7z=C:\Program Files\7-Zip\7z.exe

rem =============================
rem == create backup directory == 
rem ==== DD.MM.YYYY_hhmmmss =====
rem =============================

set h=%time:~0,2%
set h=%h: =0%
set FullBackupDir=%BackupDir%%date%_%h%%time:~3,2%%time:~6,2%\
md %FullBackupDir%

rem =============================
rem ====== copy directory =======
rem =============================

robocopy %SourceDir% %FullBackupDir%%DirName%\ /E /ZB /J /NFL /NDL /NJH /NJS /NC /NS /NP 2>nul >nul

rem =============================
rem ====== zip directory ========
rem =============================

"%a7z%" a -tzip -bb0 -bd -sdel "%FullBackupDir%%DirName%.zip" "%FullBackupDir%" 2>nul >nul

rem =============================
rem ==== remove old folders =====
rem =============================

for /f "tokens=* delims=" %%D in ('dir %BackupDir% /ad /b /o-d') do (
	if not %%D=="" (
		if not !NumFolders!==0 (
			set /a NumFolders-=1
		) else (
			rd /s /q %BackupDir%%%D 2>nul >nul
		)
	)
)