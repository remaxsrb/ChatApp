package main

import (
	"File-Service/config"
	"File-Service/router"
	"log"
)

func main() {
	config.LoadEnv()
	r := router.SetupRouter()
	if err := r.Run(":9090"); err != nil {
		log.Fatalf("Server failed to start: %v", err)
	}
}
