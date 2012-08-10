#' Return full path to the user-specific cache dir for this application.
#' 
#' Typical user cache directories are:
#'
#' \itemize{
#'  \item Mac OS X: \file{~/Library/Caches/<AppName>}
#'  \item Unix: \file{~/.cache/<appname>} (XDG default)
#'  \item Win XP: \file{C:\Documents and Settings\<username>\Local Settings\Application Data\<AppAuthor>\<AppName>\Cache}
#'  \item Vista:      \file{C:\Users\<username>\AppData\Local\<AppAuthor>\<AppName>\Cache}
#' }
#' 
#' On Windows the only suggestion in the MSDN docs is that local settings go
#' in the `CSIDL_LOCAL_APPDATA` directory. This is identical to the
#' non-roaming app data dir (the default returned by `user_data_dir` above).
#' Apps typically put cache data somewhere *under* the given dir here. Some
#' examples: \file{...\Mozilla\Firefox\Profiles\<ProfileName>\Cache}, 
#' \file{...\Acme\SuperApp\Cache\1.0}
#'
#' @section Opinion:
#' This function appends \file{Cache} to the `CSIDL_LOCAL_APPDATA` value.
#' This can be disabled with \code{opinion = FALSE} option.
#' 
#' @inheritParams user_data_dir
#' @param opinion (logical) can be \code{FALSE} to disable the appending of
#'   \file{Cache} to the base app data dir for Windows. See discussion below.
#' @export
user_cache_dir <- function(appname, appauthor, version = NULL, opinion = TRUE) {
  switch(os(), 
    win = file_path(win_path(), appauthor, appname, version, 
      if (opinion) "Cache"),
    mac = file_path("~/Library/Caches", appname, version),
    lin = file_path(Sys.getenv("XDG_CACHE_HOME", "~/.cache"),
      tolower(appname), version)
  )
}