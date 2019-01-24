---
title: "R Markdown Notes"
author: "Youran Xu"
date: "Jan 24th 2019"
output:
  word_document: default
  pdf_document: default
---

^^ Between "---" is the YAML metadata
Note: In a R markdown file, not an R script, narratives can be written as if in doc.


# Formatting

_Italic_  (_), alternatively, *Italic* (*).

**Bold** (**)

subscript: H~3~PO~4~ (~)

superscript: Cu^2+^ (^)

`text as inline code` (`)

[Hyperlink](www.google.co.uk)

^[Footnote]

> "Blockquotes"
> ---(>)

# R code chunks

Below is a code chunk({r} indicates the language we are using) 

```{r}
a <- sqrt(7)
print(a)
```

Alterntively, if quoting results in a narrative, the square root of 7 is `r a`.

- keyboard shortcut: cmd + alt + I
- `eval=` whether to execute the code chunk
- `results='hide'` to hide the text output
    - `results='asis'` to present the output in a sentence grammar, e.g. "a is 7".
- `collapse = TRUE` compacts codes and its output in one single block to save space
- `echo = FALSE` whether to include the source code, or only results
- `include = FALSE` the whole chunk will be hidden as well as the output, however, will still be executed.
- `setup` to apply this chunk globally 
    - `{r, setup, include = FALSE} knitr::opts_chunk$set(fig.width = 8, collapse = TRUE)`

# Tables
`knitr::kable()`

