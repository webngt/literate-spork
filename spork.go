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

func ClosureExample(out io.Writer) chan struct{} {
	ints := []int{1, 2, 3, 4}

	ret := make(chan struct{})
	done := make(chan struct{})

	for _, val := range ints {
		go func() {
			fmt.Fprintln(out, val)
			done <- struct{}{}
		}()
	}

	go func() {
		for i := 0; i < 4; i++ {
			<-done
		}
		close(ret)
	}()

	return ret
}

func HelloWithError() string {
	s, _ := ErrForLinter()

	return s
}
