package main

import (
	"Auth-Service/config"
	"Auth-Service/router"
	"log"
)

func main() {
	config.LoadConfig()
	r := router.SetupRouter()
	if err := r.Run(":9090"); err != nil {
		log.Fatalf("Server failed to start: %v", err)
	}
}
