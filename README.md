## FlatKit

[![Build Status](https://copiousfreetime.semaphoreci.com/badges/flat_kit/branches/main.svg)](https://copiousfreetime.semaphoreci.com/projects/flat_kit)

* [Homepage](https://github.com/copiousfreetime/flat_kit/)
* [Github Project](https://github.com/copiousfreetime/flat_kit)

## DESCRIPTION

 A library and commandline program for reading, writing, indexing,
 sorting, and merging CSV, TSV, JSON and other flat-file formats.

## FEATURES

  * Currently supporting CSV/TSV/XSV and JSON formats
  * Transparently handles gzipped compressed input or output
  * Sort records based upon the named keys of your choice
  * Efficent singles pass merge of any number of sorted input files into a
    single output file.
  * Both a commandline tool and a ruby library to utilize in your own programs


```
Usage:
  fk <command> [<args>...]
  fk [options]

Options:
  -v, --verbose    Force debug. Output lots of informtion to standard error
  --list           List all the commands
  --log=<s>        Set the logger output location (default: <stderr>)
  -h, --help       Show help message
  --version        Print version and exit

Commands:

  cat      Concatenate files together that have the same structure.
  merge    Merge sorted files together that have the same structure.
  sort     Sort a given file by a set of fields.
```

## EXAMPLES

**Convert input csv files into a single output json file**

    fk cat files/*csv -o output.json

**Sort an input json file and output it as a compressed csv**

    fk sort --key year,month,day input.json -o output.csv.gz

**Merge an entire directory of sorted record compressed csv files into a compress json file**

    fk merge --key category,timestamp sorted/*.csv.gz -o sorted.json.gz

## CREDITS / REFERENCES

* https://github.com/BurntSushi/xsv - lots of concepts and ideas pulled from xsv

## MIT LICENSE

MIT License

Copyright (c) 2021 Jeremy Hinegardner

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
