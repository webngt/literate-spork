package spork

import (
	"fmt"
	"io"
)

func Hello(m string) string {
	return fmt.Sprintf("Hello %s", m)
}

func ErrForLinter() (string, error) {
	return "Hello", fmt.Errorf("World")
}

func ClosureExample(out io.Writer) {
	ints := []int{1, 2, 3, 4}

	for _, val := range ints {
		go func() {
			fmt.Fprintln(out, val)
		}()
	}
}

func HelloWithError() string {
	s, _ := ErrForLinter()

	return s
}
