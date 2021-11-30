package main

import (
	"fmt"
	"os"

	spork "github.com/webngt/literate-spork"
)

func main() {
	s := spork.Hello("World")

	fmt.Println(s)

	s, err := spork.ErrForLinter()

	fmt.Println(s)

	if err != nil {
		fmt.Println(err)
	}

	spork.ClosureExample(os.Stdout)

}
