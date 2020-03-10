# markdown2rfc
Docker file for converting internet drafts in markdown to HTML.


To compile markdown to HTML and Text, run the following command from the directory containing the markdown file:
```bash
docker run -v `pwd`:/data danielfett/markdown2rfc markdownfile.md
```
The output files (.html and .txt) will show up in the same directory.

Hint: Add the following line to your .bashrc to run this command with the alias `makerfc`:
```bash
alias makerfc='docker run -v `pwd`:/data danielfett/markdown2rfc'
```