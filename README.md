## Generics [![Build Status](https://travis-ci.org/mmatczuk/go_generics.svg?branch=master)](https://travis-ci.org/mmatczuk/go_generics)

This project is bazel-free version of [Google go_generics tool](https://github.com/google/gvisor/blob/master/tools/go_generics) released with gVisor project. 

It allows for generating code from template while still working with standard Go code. A great example of using it is [ScyllaDB go-set](https://github.com/scylladb/go-set) package.

## Installation

```bash
go get -u github.com/mmatczuk/go_generics/cmd/go_generics
go get -u github.com/mmatczuk/go_generics/cmd/go_merge
```

## go_generics

`go_generics` reads a Go source file and writes a new version of that file with a few transformations applied to each. Namely:

1. Global types can be explicitly renamed with the -t option. For example, if `-t=A=B` is passed in, all references to `A` will be replaced with references to `B`; a function declaration like:

```go
func f(arg *A)
```

would be renamed to:

```go
func f(arg *B)
```

2. Global type definitions and their method sets will be removed when they're being renamed with `-t`. For example, if `-t=A=B` is passed in, the following definition and methods that existed in the input file wouldn't exist at all in the output file:

```go
type A struct{}

func (*A) f() {}
```

3. All global types, variables, constants and functions (not methods) are prefixed and suffixed based on the option `-prefix` and `-suffix` arguments. For example, if `-suffix=A` is passed in, the following globals:

```go
func f()
type t struct{}
```

would be renamed to:

```go
func fA()
type tA struct{}
```

Some special tags are also modified. For example:

```go
"state:.(t)"
```

would become:

```go
"state:.(tA)"
```

4. The package is renamed to the value via the `-p` argument. 

5. Value of constants can be modified with `-c` argument. Note that not just the top-level declarations are renamed, all references to them are also properly renamed as well, taking into account visibility rules and shadowing. For example, if `-suffix=A` is passed in, the following:

```go
var b = 100

func f() {

    g(b)
    b := 0
    g(b)

}
```

Would be replaced with:

```go
var bA = 100

func f() {

    g(bA)
    b := 0
    g(b)

}
```

Note that the second call to `g()` kept "b" as an argument because it refers to the local variable "b".

Unfortunately, `go_generics` does not handle anonymous fields with renamed types.

## go_merge

`go_merge` merges multiple Go files into one, may be used in a pipeline before `go_generics`. 

## License

This project is distributed under the Apache 2.0 license. See the [LICENSE](https://github.com/scylladb/gocqlx/blob/master/LICENSE) file for details.
It contains software from:

* [github.com/google/gvisor](https://github.com/google/gvisor), licensed under the Apache 2.0 license.

GitHub star is always appreciated!
