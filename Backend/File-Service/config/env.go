package config

import (
	"github.com/joho/godotenv"
	"log"
	"os"
)

var FileServeURL string

func LoadEnv() {
	err := godotenv.Load()
	if err != nil {
		log.Fatal("Error loading .env file")
	}

	FileServeURL = os.Getenv("FILE_SERVE_URL")
}
