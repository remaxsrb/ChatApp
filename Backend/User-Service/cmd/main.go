package main

import (
	"User-Service/config"
	"User-Service/router"
	"log"
)

func main() {
	// Load environment variables
	config.LoadConfig()

	// Initialize PostgreSQL DB
	config.InitPostgresDB()

	// Initialize Redis
	config.InitRedis()

	// Set up router
	r := router.SetupRouter()

	log.Printf("Starting HTTP server on %s", config.BackendURL)
	if err := r.Run(config.BackendURL); err != nil {
		log.Fatalf("Server failed to start: %v", err)
	}
}
