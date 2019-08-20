css_dependency <- function(name, files) {
  list(
    htmltools::htmlDependency(
      name,
      version    = utils::packageVersion("parsons"),
      src        = "htmlwidgets/plugins/parsons",
      package    = "parsons",
      stylesheet = files,
      all_files = FALSE
    )
  )
}



parsons_dependencies <- function() {
  css_dependency("parsons", "parsons.css")
}
