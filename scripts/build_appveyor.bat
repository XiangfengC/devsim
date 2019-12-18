
:: SET_USE_CYGWIN is true for Visual Studio Builds
IF "%PLATFORM%"=="msys" (
  SET CONDA_PATH=c:\Miniconda37-x64\Library\bin\conda.bat
  SET BUILDDIR=msys
  SET PACKAGE_NAME="devsim_msys_%APPVEYOR_REPO_TAG_NAME%"
)

IF "%PLATFORM%"=="x64" (
  SET CONDA_PATH=c:\Miniconda37-x64\Scripts\conda
  SET BUILDDIR=win64
  SET USE_CYGWIN=true
  SET PACKAGE_NAME="devsim_win64_%APPVEYOR_REPO_TAG_NAME%"
)

IF "%PLATFORM%"=="x86" (
  SET CONDA_PATH=c:\Miniconda37\Scripts\conda
  SET BUILDDIR=win32
  SET USE_CYGWIN=true
  SET PACKAGE_NAME="devsim_win32_%APPVEYOR_REPO_TAG_NAME%"
)

:: GET PREREQUISITES
IF DEFINED USE_CYGWIN (
  %CONDA_PATH% install --yes mkl mkl-devel mkl-include sqlite zlib
  if %errorlevel% neq 0 exit /b %errorlevel%

  appveyor DownloadFile https://cygwin.com/setup-x86.exe
  if %errorlevel% neq 0 exit /b %errorlevel%

  setup-x86.exe -qnNdO -R C:/cygwin -s http://cygwin.mirror.constant.com -l C:/cygwin/var/cache/setup -P flex -P bison -P zip
  if %errorlevel% neq 0 exit /b %errorlevel%

:: BUILD DEPENDENCIES
  cd %APPVEYOR_BUILD_FOLDER%\external
  c:\cygwin\bin\bash.exe ./build_superlu_appveyor.sh %PLATFORM%
  if %errorlevel% neq 0 exit /b %errorlevel%

  cd %APPVEYOR_BUILD_FOLDER%\external\symdiff
  c:\cygwin\bin\bash.exe ../symdiff_appveyor.sh %PLATFORM%
  if %errorlevel% neq 0 exit /b %errorlevel%

  cd %BUILDDIR%
  cmake --build . --config Release -- /m /nologo /verbosity:minimal
  if %errorlevel% neq 0 exit /b %errorlevel%

:: BUILD DEVSIM
  cd %APPVEYOR_BUILD_FOLDER%
  c:\cygwin\bin\bash.exe scripts/setup_appveyor.sh %PLATFORM%
  if %errorlevel% neq 0 exit /b %errorlevel%

  cd %BUILDDIR%
  cmake --build . --config Release -- /m /v:m
  if %errorlevel% neq 0 exit /b %errorlevel%

:: PACKAGE DEVSIM
  cd %APPVEYOR_BUILD_FOLDER%\dist
  c:\cygwin\bin\bash.exe package_appveyor.sh "%PACKAGE_NAME%"
  if %errorlevel% neq 0 exit /b %errorlevel%
) ELSE (
  %CONDA_PATH% create --yes -n devsim_build python=3.7
  if %errorlevel% neq 0 exit /b %errorlevel%
  CALL %CONDA_PATH% activate devsim_build
  if %errorlevel% neq 0 exit /b %errorlevel%
  conda install --yes mkl mkl-devel mkl-include sqlite zlib boost cmake
  cd %APPVEYOR_BUILD_FOLDER%
  c:\msys64\usr\bin\bash %APPVEYOR_BUILD_FOLDER%\scripts\build_msys.sh "%PACKAGE_NAME%"
  if %errorlevel% neq 0 exit /b %errorlevel%
)
