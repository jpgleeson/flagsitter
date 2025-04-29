## Flagsitter

Flagsitter is a small utility library for Odin that duplicates the Go [flags](https://pkg.go.dev/flag) interface.

Currently Flagsitter supports String and Int arguments.

## Usage
```
package main

import "core:fmt"
import "core:os"

import "flagsitter"

main :: proc() {
	flags := os.args[1:]
	flagSitter := flagsitter.create(flags)

	filename: string
	intArgument: int
	flagsitter.StringArg(&flagSitter, &filename, "-f", "")
	flagsitter.IntArg(&flagSitter, &intArgument, "-d", 100)
	flagsitter.Parse(&flagSitter)

	fmt.println(filename)
	fmt.println(intArgument)
}

```
