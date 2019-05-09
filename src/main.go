package main

import (
	"fmt"
	"net/http"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello World: %s\n", r.URL.Path)
	})
	http.ListenAndServe(":8088", nil)
}
