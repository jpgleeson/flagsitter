package flagsitter

import "core:fmt"
import "core:strconv"
import "core:strings"

FlagSitter :: struct {
	args:         []string,
	string_binds: map[string]^string,
	int_binds:    map[string]^int,
}

// create initializes a new FlagSitter instance with the provided arguments.
//
// Parameters:
//   desArgs - The command-line arguments to parse (typically os.args[1:])
//
// Returns:
//   A new FlagSitter instance ready for argument definitions
create :: proc(desArgs: []string) -> FlagSitter {
	return FlagSitter {
		args = desArgs,
		string_binds = make(map[string]^string),
		int_binds = make(map[string]^int),
	}
}

// destroy frees resources allocated by a FlagSitter instance.
// Should be called with defer after creating a FlagSitter.
//
// Parameters:
//   sitter - Pointer to the FlagSitter instance to clean up
destroy :: proc(sitter: ^FlagSitter) {
	delete(sitter.string_binds)
}

// StringArg registers a string flag with a FlagSitter instance and binds it to the target.
//
// Parameters:
//  sitter - Pointer to the FlagSitter instance
//  target - Pointer to the target variable
//  flag - The flag name (including the dash)
//  defaultValue - The default value to set if the flag is not provided or the input is invalid
StringArg :: proc(sitter: ^FlagSitter, target: ^string, flag: string, defaultValue: string) {
	target^ = defaultValue
	sitter.string_binds[flag] = target
}

// IntArg registers an int flag with a FlagSitter instance and binds it to the target.
//
// Parameters:
//  sitter - Pointer to the FlagSitter instance
//  target - Pointer to the target variable
//  flag - The flag name (including the dash)
//  defaultValue - The default value to set if the flag is not provided or the input is invalid
IntArg :: proc(sitter: ^FlagSitter, target: ^int, flag: string, defaultValue: int) {
	target^ = defaultValue
	sitter.int_binds[flag] = target
}

// Parse processes the arguments based on the defined bindings.
// It iterates through the command-line arguments and updates bound variables
// with their corresponding values.
//
// Parameters:
//   sitter - Pointer to the FlagSitter instance to parse
//
// Example:
//   ```
//   sitter := flagsitter.create(os.args[1:])
//   defer flagsitter.destroy(&sitter)
//
//   filename: string
//   count: int
//
//   flagsitter.StringArg(&sitter, &filename, "-f", "default.txt")
//   flagsitter.IntArg(&sitter, &count, "-c", 10)
//
//   flagsitter.Parse(&sitter)
//   ```
Parse :: proc(sitter: ^FlagSitter) {
	i := 0
	for i < len(sitter.args) {
		currentArg := sitter.args[i]

		if strings.has_prefix(currentArg, "-") {
			// if it's a string arg, handle string
			if target, ok := sitter.string_binds[currentArg]; ok {
				if i + 1 < len(sitter.args) {
					target^ = sitter.args[i + 1]
					i += 2
					continue
				}
			}

			// if it's an int arg, parse the int and set
			if target, ok := sitter.int_binds[currentArg]; ok {
				if i + 1 < len(sitter.args) {
					valStr := sitter.args[i + 1]
					val, ok := strconv.parse_int(valStr)
					if ok {
						target^ = val
					}
					i += 2
					continue
				}
			}
		}
		i += 1
	}
}
