move_yaml <- function(yaml, body, what = "questions", dovetail = TRUE) {
  ln        <- xml_list_chunk(yaml, what, dovetail = dovetail)
  to_insert <- xml2::xml_child(ln)
  where <- if (what == "keypoints") length(xml2::xml_children(body)) else 1L
  xml_slip_in(body, to_insert, where)
}

