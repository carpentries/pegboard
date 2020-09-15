move_yaml <- function(yaml, body, what = "questions", dovetail = TRUE) {
  ln        <- xml_list_chunk(yaml, what, dovetail = dovetail)
  to_insert <- xml2::xml_children(ln)
  xml2::xml_set_attr(to_insert, "dtag", what)
  where <- if (what == "keypoints") length(xml2::xml_children(body)) else 1L
  for (i in rev(to_insert)) {
    xml_slip_in(body, i, where)
  }
}

