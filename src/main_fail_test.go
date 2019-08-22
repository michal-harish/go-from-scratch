package main

import (
	"gotest.tools/v3/assert"
	"testing"
)

func TestSomethingFailing(t *testing.T) {
	assert.Equal(t, 1, 0)
}

