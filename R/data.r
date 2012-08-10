#' Return full path to the user-specific data dir for this application.
#' 
#' Typical user data directories are:
#'
#' \itemize{
#'   \item Mac OS X:  \file{~/Library/Application Support/<AppName>}
#'   \item Unix: \file{~/.config/<appname>}, in \env{$XDG_CONFIG_HOME} if
#'      defined
#'   \item Win XP (not roaming):  \file{C:\Documents and Settings\<username>\Application Data\<AppAuthor>\<AppName>}
#'   \item Win XP (roaming): \file{C:\Documents and Settings\<username>\Local Settings\Application Data\<AppAuthor>\<AppName>}
#'   \item Win 7  (not roaming): 
#'     \file{C:\Users\<username>\AppData\Local\<AppAuthor>\<AppName>}
#'   \item Win 7 (roaming):      
#'     \file{C:\Users\<username>\AppData\Roaming\<AppAuthor>\<AppName>}
#' 
#' For Unix, we follow the XDG spec and support \env{$XDG_CONFIG_HOME}. We
#' don't use \env{$XDG_DATA_HOME} as that data dir is mostly used at the time
#' of installation, instead of the application adding data during runtime.
#' Also, in practice, Linux apps tend to store their data in
#' \file{~/.config/<appname>} instead of \file{~/.local/share/<appname>}.
#'
#' @param appname is the name of application.
#' @param appauthor (only required and used on Windows) is the name of the
#'     appauthor or distributing body for this application. Typically
#'     it is the owning company name.
#' @param version is an optional version path element to append to the
#'     path. You might want to use this if you want multiple versions
#'     of your app to be able to run independently. If used, this
#'     would typically be "<major>.<minor>".
#' @param roaming (logical, default \code{FALSE}) can be set \code{TRUE} to
#'     use the Windows roaming appdata directory. That means that for users on
#'     a Windows network setup for roaming profiles, this user data will be
#'     sync'd on login. See
#'     \url{http://technet.microsoft.com/en-us/library/cc766489(WS.10).aspx}
#'     for a discussion of issues.
#' @export
user_data_dir <- function(appname, appauthor, version = NULL, roaming = FALSE) {
  csidl <- if (roaming) CSIDL_APPDATA else CSIDL_LOCAL_APPDATA
  
  switch(os(), 
    win = file_path(win_path(csidl), appauthor, appname, version),
    mac = file_path("~/Library/Application Support", appname, version),
    lin = file_path(Sys.getenv("XDG_CONFIG_HOME", "~/.config"), 
      tolower(appname), version)
  )
}


#' Return full path to the user-shared data dir for this application.
#' 
#' Typical user data directories are:
#' 
#' \itemize{
#' \item Mac OS X:   \file{/Library/Application Support/<AppName>}
#' \item Unix:       \file{/etc/xdg/<appname>}
#' \item Win XP:     \file{C:\Documents and Settings\All Users\Application Data\<AppAuthor>\<AppName>}
#' \item Vista:      (Fail! file{C:\ProgramData} is a hidden \emph{system}
#'    directory on Vista.)
#' \item Win 7:      \file{C:\ProgramData\<AppAuthor>\<AppName>}.  
#'    Hidden, but writeable on Win 7.
#' }
#' 
#' For Unix, this is using the \env{$XDG_CONFIG_DIRS[0]} default.
#' 
#' @inheritParams user_data_dir
#' @section Warning:
#' Do not use this on Windows. See the note above for why.
#' @export
site_data_dir <- function(appname, appauthor, version = NULL) {
  switch(os(),
    win = file_path(win_path(), appauthor, appname, version),
    mac = file_path("/Library/Application Support", appname, version),
    lin = file_path("/etc/xdg", tolower(appname), version)    
  )
}