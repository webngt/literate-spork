package literate_spork

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestHello(t *testing.T) {
	res := Hello("world")
	assert.Equal(t, "Hello wrld", res)
}
