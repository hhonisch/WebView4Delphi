unit uWVConstants;

{$IFDEF FPC}{$MODE Delphi}{$ENDIF}

interface

const
  WEBVIEW2LOADERLIB_VERSION_MAJOR   = 1;
  WEBVIEW2LOADERLIB_VERSION_MINOR   = 0;
  WEBVIEW2LOADERLIB_VERSION_RELEASE = 1054;
  WEBVIEW2LOADERLIB_VERSION_BUILD   = 31;

  CHROMIUM_VERSION_MAJOR   = 96;
  CHROMIUM_VERSION_MINOR   = 0;
  CHROMIUM_VERSION_RELEASE = 1054;
  CHROMIUM_VERSION_BUILD   = 34;

  CRLF = #13 + #10;

  {$IFDEF FPC}
  USER_DEFAULT_SCREEN_DPI = 96;
  {$ENDIF}

  // These contants are declared in the "Windows" unit but
  // some old Delphi versions don't have them.
  // We have to add "WV2_" to be compatible with C++ Builder.
  WV2_IMAGE_FILE_MACHINE_I386  = $014C;
  WV2_IMAGE_FILE_MACHINE_AMD64 = $8664;

  ZOOM_STEP_25  = 0;
  ZOOM_STEP_33  = 1;
  ZOOM_STEP_50  = 2;
  ZOOM_STEP_67  = 3;
  ZOOM_STEP_75  = 4;
  ZOOM_STEP_90  = 5;
  ZOOM_STEP_100 = 6;
  ZOOM_STEP_110 = 7;
  ZOOM_STEP_125 = 8;
  ZOOM_STEP_150 = 9;
  ZOOM_STEP_175 = 10;
  ZOOM_STEP_200 = 11;
  ZOOM_STEP_250 = 12;
  ZOOM_STEP_300 = 13;
  ZOOM_STEP_400 = 14;
  ZOOM_STEP_500 = 15;
  ZOOM_STEP_UNK = 16;
  ZOOM_STEP_MIN = ZOOM_STEP_25;
  ZOOM_STEP_MAX = ZOOM_STEP_500;
  ZOOM_STEP_DEF = ZOOM_STEP_100;

  ZOOM_PCT_DELTA = 5;

  ZoomStepValues : array[ZOOM_STEP_MIN..ZOOM_STEP_MAX] of integer = (25, 33, 50, 67, 75, 90, 100, 110, 125, 150, 175, 200, 250, 300, 400, 500);

  URI_ABOUTBLANK = 'about:blank';

implementation

end.
