terraform {
  required_version = ">= 0.13.0"
}

locals {
  encoded = jsonencode(var.object)
  unescaped = replace(replace(replace(replace(replace(local.encoded,
    "\\u003c", "<"),
    "\\u003e", ">"),
    "\\u0026", "&"),
    "\\u2028", "\u2028"),
    "\\u2029", "\u2029"
  )
}
