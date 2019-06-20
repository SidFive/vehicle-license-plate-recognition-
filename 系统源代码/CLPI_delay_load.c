/*
 * MATLAB Compiler: 4.13 (R2010a)
 * 
 * Manages error reporting when MCLMCRRT (the generated application's interface
 * to the MCR) DLL cannot be found.
 *
 * This functionality is specific to Microsoft Windows and the MSVC compilers. 
 * Win32 means the Win32 API; this function works on both 32 and 64-bit 
 * Windows machines. 
 */

#include <Windows.h>

/* This include and pragma are only available to MSVC compilers. */
#if defined(_WIN32) && (_MSC_VER >= 1200)
#include <DelayImp.h>
#pragma comment(lib, "Delayimp.lib")
#endif


#ifndef __LCC__
static void FailedToLoadMCR(void)
{
    const LPCSTR mcrMsg = "Could not find version 7.13 of the MCR.\nAttempting to load mclmcrrt713.dll.\nPlease install the correct version of the MCR.\nContact your vendor if you do not have an installer for the MCR.";
    MessageBox(NULL, mcrMsg, "Failed to load MCR.",
               MB_ICONERROR);
    exit(-1);
}
#endif

#if defined(_WIN32) && (_MSC_VER >= 1200)

/* This function is automatically called by Microsoft Windows when a 
 * "delay load" DLL fails to load.
 */
FARPROC WINAPI CLPIDelayLoadWin32FailureHook (unsigned dliNotify, PDelayLoadInfo pdli)
{
   FARPROC fp = NULL;   // Default return value

   switch (dliNotify)
   {
   case dliFailLoadLib:
       // Failed to load the DLL. If the DLL's name contains "mclmcrrt" then
       // return a handle to the executable's module, so that the system
       // "failed to load" message does not appear. When the program attempts
       // to call a function in the MCLMCRRT DLL, we'll enter the 
       // dliFailGetProc case below.
  
       fp = NULL;
       if (pdli != NULL && strstr(pdli->szDll, "mclmcrrt"))
       {
         // Unavoidable cast, due to Microsoft's use of casting in
         // vc/include/delayhlp.cpp.
         fp = (FARPROC) GetModuleHandle(NULL);
       }
       break;

   case dliFailGetProc:
       // GetProcAddress failed. If the DLL name contains MCLMCRRT, then
       // return a pointer to our "failure" function. The application will
       // call FailedToLoadMCR, which will issue an error message and
       // then exit. It is safe to exit because we're only using this
       // technique in generated executables, in which we own the entire
       // application -- and failing to load a DLL is a fatal error.

       if (pdli != NULL && strstr(pdli->szDll, "mclmcrrt"))
       {
           fp = (FARPROC) FailedToLoadMCR;
       }
       break;
   }

   return(fp);
}

// __delayLoadHelper gets the hook function in here:
#if (defined(DELAYLOAD_VERSION) && (DELAYLOAD_VERSION >= 0x0200)) || (defined(_DELAY_IMP_VER) && (_DELAY_IMP_VER >= 2))
PfnDliHook __pfnDliFailureHook2 = CLPIDelayLoadWin32FailureHook;
#else
PfnDliHook __pfnDliFailureHook = CLPIDelayLoadWin32FailureHook;
#endif

#endif

