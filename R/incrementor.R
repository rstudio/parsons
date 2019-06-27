incrementor <- function(prefix = "increment_"){
  i <-  0
  function(){
    i <<- i + 1
    paste0(prefix, i)
  }
}

increment_parsons <- incrementor("parsons_list_id_")
increment_parsons_group <- incrementor("parsons_group_")
