# terraform-null-jsonencode-no-replacements
A module to do a jsonencode without replacing special characters.

Per the `jsonencode` [documentation](https://www.terraform.io/docs/language/functions/jsonencode.html),  

> When encoding strings, this function escapes some characters using Unicode escape sequences: replacing <, >, &, U+2028, and U+2029 with \u003c, \u003e, \u0026, \u2028, and \u2029. This is to preserve compatibility with Terraform 0.11 behavior.

Since in most cases we no longer need Terraform 0.11 compatibility and this escaping can cause problems, this module does a standard `jsonencode` but does *not* escape these characters.

**Note:** Since there's no way to know prior to using `jsonencode` whether the original object contains any literal strings that match the unicode representations that Terraform replaces values with, they cannot be "protected" from the un-replacing that this module performs to reverse Terraform's escaping. That is to say, if the original object contains the literal string "\u0026", in the JSON representation output of this module that string literal will be replaced with "&".

Usage:

```
locals {
  to_encode = {
    greater  = ">"
    less     = " <"
    amp      = "&"
    line_sep = "\u2028"
    para_sep = "\u2029"
  }
}

module "jsonencode_no_replacements" {
  source  = "Invicton-Labs/jsonencode-no-replacements/null"
  object = local.to_encode
}

output "jsonencode_no_replacements" {
  // Add a period at the end so Terraform outputs it as a string
  value = "${module.jsonencode_no_replacements.encoded}."
}

output "jsonencode_standard" {
  // Add a period at the end so Terraform outputs it as a string
  value = "${jsonencode(local.to_encode)}."
}

```

```
jsonencode_no_replacements = "{\"amp\":\"&\",\"greater\":\">\",\"less\":\" <\",\"line_sep\":\"\u2028\",\"para_sep\":\"\u2029\"}."

jsonencode_standard = "{\"amp\":\"\\u0026\",\"greater\":\"\\u003e\",\"less\":\" \\u003c\",\"line_sep\":\"\\u2028\",\"para_sep\":\"\\u2029\"}."
```