package config

import (
	"github.com/joho/godotenv"
	"log"
	"os"
)

// JWT
var JWTSecret string

var UserServiceURL string

func LoadConfig() {
	err := godotenv.Load()
	if err != nil {
		log.Fatal("Error loading .env file")
	}
	JWTSecret = os.Getenv("JWT_SECRET_KEY")
	UserServiceURL = os.Getenv("USER_SERVICE_URL")
}
