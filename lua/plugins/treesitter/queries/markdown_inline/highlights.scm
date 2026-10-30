; From MDeiml/tree-sitter-markdown
(code_span) @markup.raw @nospell

(emphasis) @markup.italic

(strong_emphasis) @markup.strong

(strikethrough) @markup.strikethrough

(shortcut_link
  (link_text) @nospell)

[
  (backslash_escape)
  (hard_line_break)
] @string.escape

; Text style markers (* _ ~ **) are left alone on purpose: they keep the
; highlight of the enclosing node, e.g. @markup.italic for emphasis.


; Conceal inline links
; Only conceal the brackets, keep '(...)' and the destination visible so links
; render as: 󰖟 documentation(https://example.com)
(inline_link
  [
    "["
    "]"
  ] @markup.link
  (#set! conceal ""))

[
  (link_label)
  (link_text)
  (link_title)
  (image_description)
] @markup.link.label

((inline_link
  (link_destination) @_url) @_label
  (#set! @_label url @_url))

((image
  (link_destination) @_url) @_label
  (#set! @_label url @_url))

; Conceal image links
; Only conceal the '![]' marker, keep '(...)' and the destination visible so
; images render as: 󰖟 alt(https://example.com/i.png)
(image
  [
    "!"
    "["
    "]"
  ] @markup.link
  (#set! conceal ""))

; Parentheses of a link destination are visible -> color them like the URL.
(inline_link
  ["(" ")"] @markup.link.url)

(image
  ["(" ")"] @markup.link.url)

; Conceal full reference links
; Keep the reference label visible so it renders as: text[label]
(full_reference_link
  "[" @markup.link
  (link_text)
  "]" @markup.link
  (#set! conceal ""))

; Conceal collapsed reference links
(collapsed_reference_link
  [
    "["
    "]"
  ] @markup.link
  (#set! conceal ""))

; Conceal shortcut links
(shortcut_link
  [
    "["
    "]"
  ] @markup.link
  (#set! conceal ""))

[
  (link_destination)
  (uri_autolink)
  (email_autolink)
] @markup.link.url @nospell

((uri_autolink) @_url
  (#offset! @_url 0 1 0 -1)
  (#set! @_url url @_url))

(entity_reference) @nospell

; Replace common HTML entities.
((entity_reference) @character.special
  (#eq? @character.special "&nbsp;")
  (#set! conceal " "))

((entity_reference) @character.special
  (#eq? @character.special "&lt;")
  (#set! conceal "<"))

((entity_reference) @character.special
  (#eq? @character.special "&gt;")
  (#set! conceal ">"))

((entity_reference) @character.special
  (#eq? @character.special "&amp;")
  (#set! conceal "&"))

((entity_reference) @character.special
  (#eq? @character.special "&quot;")
  (#set! conceal "\""))

((entity_reference) @character.special
  (#any-of? @character.special "&ensp;" "&emsp;")
  (#set! conceal " "))
