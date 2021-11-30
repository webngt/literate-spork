package spork

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestHello(t *testing.T) {
	res := Hello("world")
	assert.Equal(t, "Hello wold", res)
}

func TestHelloWithErr(t *testing.T) {
	res := HelloWithError()

	assert.Equal(t, "Hello", res)
}
