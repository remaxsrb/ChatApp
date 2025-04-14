package main

import (
	"FileServing/router"
	"log"
)

func main() {
	r := router.SetupRouter()
	if err := r.Run(":9090"); err != nil {
		log.Fatalf("Server failed to start: %v", err)
	}
}
