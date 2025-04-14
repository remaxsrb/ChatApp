package config

import (
	"fmt"
	"log"
	"os"

	"github.com/joho/godotenv"
)

// PostgreSQL Database configuration
var (
	PostgresHost     string
	PostgresPort     string
	PostgresUser     string
	PostgresPassword string
	PostgresDB       string
)

// Fronted-URL
var FrontendURL string

// Backend-URL
var BackendURL string
var GoServerPort string

var AuthServiceURL string
var FileServiceURL string

var ClientFileServeURL string

func LoadConfig() {
	// Load .env file
	err := godotenv.Load()
	if err != nil {
		log.Fatal("Error loading .env file")
	}

	// Retrieve environment variables
	PostgresHost = os.Getenv("POSTGRES_HOST")
	PostgresPort = os.Getenv("POSTGRES_PORT")
	PostgresUser = os.Getenv("POSTGRES_USER")
	PostgresPassword = os.Getenv("POSTGRES_PASSWORD")
	PostgresDB = os.Getenv("POSTGRES_DB")

	GoServerPort = os.Getenv("GO_SERVER_PORT")

	FrontendURL = os.Getenv("FRONTEND_URL")
	BackendURL = os.Getenv("BACKEND_URL")

	AuthServiceURL = os.Getenv("AUTH_SERVICE_URL")

	FileServiceURL = os.Getenv("FILE_SERVICE_URL")

	ClientFileServeURL = os.Getenv("CLIENT_FILE_SERVE_URL")

	if PostgresHost == "" || PostgresPort == "" || PostgresUser == "" || PostgresPassword == "" || PostgresDB == "" || GoServerPort == "" {
		log.Fatal("Missing required environment variables!")
	}

	fmt.Printf("Configuration loaded: DB=%s:%s, GoServerPort=%s\n", PostgresHost, PostgresPort, GoServerPort)
}
