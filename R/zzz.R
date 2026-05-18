.onLoad <- function(libname, pkgname) {
  
  .env_warn <- Sys.getenv("_R_WARN_", unset = NA)
  
  if (is.na(.env_warn) || .env_warn != "suppress") {
    old_warn <- getOption("warn")
    assign(".TOmicsVis_old_warn", old_warn, 
           envir = asNamespace(pkgname))
    
    options(warn = -1L)
  }
  
  invisible()
}

.onAttach <- function(libname, pkgname) {
  
  if (exists(".TOmicsVis_old_warn", envir = asNamespace(pkgname))) {
    old_warn <- get(".TOmicsVis_old_warn", 
                     envir = asNamespace(pkgname))
    options(warn = old_warn)
  }
  
  packageStartupMessage(
    "Welcome to TOmicsVis v", 
    utils::packageDescription(pkgname, fields = "Version"),
    "! An All-in-One Transcriptomic Analysis and Visualization Package."
  )
}