@echo off
setlocal enabledelayedexpansion

:: Pobierz pełną ścieżkę do pliku tekstowego od użytkownika
set /p file_path=Podaj pełną ścieżkę do pliku tekstowego (.txt):

:: Sprawdź czy plik istnieje
if not exist "%file_path%" (
    echo Plik "%file_path%" nie istnieje.
    pause
    exit /b
)

echo.
echo Odczyt pliku: %file_path%
echo.

:: Czytanie pliku linia po linii
for /f "usebackq delims=" %%L in ("%file_path%") do (
    set "line=%%L"
    setlocal enabledelayedexpansion

    rem Usuń białe znaki na początku i końcu (w miarę możliwości)
    for /f "tokens=* delims= " %%a in ("!line!") do set "line=%%a"

    if "!line!"=="" (
        endlocal
        goto :continue
    )

    rem Obsługa <text>...</t>
    echo !line! | find "<text>" >nul
    if !errorlevel! == 0 (
        set "text=!line:*<text>=!"
        for /f "delims=<" %%t in ("!text!") do echo %%t
        endlocal
        goto :continue
    )

    rem Obsługa <path>...</p>
    echo !line! | find "<path>" >nul
    if !errorlevel! == 0 (
        set "path=!line:*<path>=!"
        for /f "delims=<" %%p in ("!path!") do (
            echo Otwarcie ścieżki: %%p
            start "" "%%p"
        )
        endlocal
        goto :continue
    )

    rem Obsługa <run>...</r>
    echo !line! | find "<run>" >nul
    if !errorlevel! == 0 (
        set "cmd=!line:*<run>=!"
        for /f "delims=<" %%r in ("!cmd!") do (
            echo Uruchamianie: %%r
            start "" %%r
        )
        endlocal
        goto :continue
    )

    echo Nieznane polecenie lub format: !line!
    endlocal

    :continue
)

echo.
echo Gotowe.
pause
