# Markdown-to-PDF
## Requirements
- pandoc
  - pandoc-crossref
- pLaTeX
- Python
  
## Directories
```
.
├── Makefile
├── README.md
├── cross-ref.config.yml
├── dists                   : PDF as build outputs
├── scripts                 : scripts for modify converted latex files
├── src                     : markdown files as a src
│   ├── abstract.md
│   ├── main.md
│   ├── img
│   └── metadata.tex        : Metadata such as a title or authors.
├── template
│   └── template.tex        : template latex file
└── tmp
```

## How to use
- Write contents as markdown in `src` dir.
- build
  ```
  make 
  ```
- You can get a pdf file in `dists` dir.

## How to write
### Write structure as markdown in `src`
  ```
  # Section
  ## Subsection
  ### SubSubsection
  ```
### Import images
  - you can add tag for images
  ```
  ![TESTIMAGE](img/testimg.pdf){#fig:test}
  ```
  - If you want to put a wide image, please tag with `fig:wide` prefix.
  ```
  ![TESTIMAGE](img/testimg.pdf){#fig:wide:test}
  ```
### Tagging
  - Tag
    ```
    {#fig:test}
    ```
  - Referring
    ```
    [@fig:test]
    ```
### Reference
- Add bibtex entry in `src/myBibTex.bib`.
- Reffering in markdown by latex `cite` command.
  ```
  Bitcoin \cite{nakamoto2008bitcoin}
  ```

### Tips
- To type double-quotes in JIS Keyboard
  - “(start): `Option + @`
  - ”(end): `Option + Shift + @`