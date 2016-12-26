#' Manage custom templates for ProjectTemplate
#'
#' This function allows custom templates to be created and deleted which can
#' be used during \code{\link{create.project}} to enhance the core project layout
#' with content specific to the user's requirements.
#' 
#'
#' @param command A character string containing a command to apply to the installed
#'   templates.  Full description of each command is given below.
#' @param template.name The string name or number of the custom
#'   template that the command should be applied to.  Template numbers can be found
#'   by the \code{templates()} command.  
#' @param location A character string containing the location of a custom
#'   template.  Should be in the form \code{local::/path/to/template} or
#'   \code{github:githubname/repository:path/to/template}
#'   
#' @return No value is returned; this function is called for its side effects.
#'
#'   
#' @details 
#' When a template is specified with a \code{create.project()} call, then the content
#' of that template is merged in with the standard layout provided by \code{Projecttemnplate}.
#' Templates can be stored in local filesystem directories or on github. 
#' 
#' The \code{config/globals.dcf} configuration file is treated specially if it is present in
#' the template.  The template only needs to contain the specific parameters that the user wants
#' to have different from the default.  The \code{templates()} function will take care of filling
#' in the rest of the values with the standard defaults and ensure the correct version number
#' is in place.  This means that templates don't have to keep up to date with new config parameters
#' if they don't need to.
#' 
#' The template configuration
#' is stored within the local \code{R} configuration and is preserved between package updates of
#' \code{ProjectTemplate}.  However, if \code{R} is upgraded, the template configuration will need to
#' be reloaded using \code{templates("backup")} and \code{templates("restore")}.
#' 
#' The command parameters are shown below.
#' \tabular{ll}{
#'  \code{show} \tab This shows the currently installed templates in the system \cr
#'  \code{config} \tab This shows the detailed configuration of each installed templates \cr
#'  \code{add} \tab This allows the template specified in \code{location} to be added to the
#'     list of installed templates \cr
#'  \code{remove} \tab This allows the template specified in \code{template.name} to be removed from the
#'     list of installed templates \cr
#'  \code{setdefault} \tab This allows the template specified in \code{template.name} to be the default
#'     template applied when \code{create.project()} is called without the \code{template.name} parameter \cr
#'  \code{nodefault} \tab This means that no template is applied when \code{create.project()} is called
#'     unless the \code{template.name} parameter is present \cr
#'  \code{clear} \tab This removes all custom templates from the current installation \cr
#'  \code{backup} \tab Create the raw template file in the current working directory or the
#'      directory specified in \code{location} parameter \cr
#'  \code{restore} \tab Reads a raw template file in the current working directory named 
#'      \code{ProjectTemplateRootConfig.dcf} or the file specified in \code{location} parameter \cr
#'  }
#'
#' @seealso \code{\link{load.project}}, \code{\link{get.project}},
#'   \code{\link{cache.project}}, \code{\link{show.project}}
#'
#' @export
#'
#' @examples
#' library('ProjectTemplate')
#'
#' \dontrun{
#'     templates()
#'     
#'     # name of template is my_template (default directory name if not specified)
#'     templates("add", location="local::/path/to/my_template)  
#'     
#'     # name of template is gitTemp 
#'     templates("add", "gitTemp",location="github:username/reponame:/my_template) 
#'     }
templates <- function(command = "show", template.name = NULL, location = NULL)
{
  
  # perform the requested command
  switch(command,
         show ={
                 # Nothing additional to do 
                 
         },
         
         config ={
                 .root.template.status(full=TRUE)
                 .quietstop()
         }, 
         
         add ={
                 if (is.null(location))
                         stop("Please provide location parameter of the template to add")
                 if (is.null(template.name)) template.name <- basename(location)
                 .add.template.location(template.name, location)
                 
         },
         
         remove ={
                 if (is.null(template.name))
                         stop("Please provide template name or number to remove")
                 .remove.template.location(template.name)
         },
         
         setdefault ={
                  if (is.null(template.name))
                         stop("Please provide template name or number that you want to make default")
                 .set.default.template(template.name)
         },
         
         nodefault ={
                .no.default.template() 
         },
         
         clear ={
                 .clear.root.template()
         },
         
         backup ={
                 if (!is.null(location) && dir.exists(location))
                        .backup.root.template(location)
                 else
                        .backup.root.template()
         },
         
         restore ={
                 if (is.null(location))
                        .restore.root.template() 
                 else
                        .restore.root.template(location)
         }
  )
        
  .root.template.status()
  
}
