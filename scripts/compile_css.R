
if (!require(sass)) {
  install.packages("sass")
}
library(sass)

scss_files <- dir(
  file.path("inst", "htmlwidgets", "plugins", "parsons"),
  pattern = "^[^_].*?\\.scss",
  full.names = TRUE
)

for (scss_file in scss_files) {
  message("Translating: ", basename(scss_file))
  sass::sass(
    input = sass::sass_file(scss_file),
    output = sub("\\.scss", ".css", scss_file)
  )
}
