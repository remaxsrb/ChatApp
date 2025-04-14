package config

import (
	"User-Service/models"
	"fmt"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"log"
)

var DB *gorm.DB

func InitPostgresDB() {
	DomainSourceName := fmt.Sprintf("host=%s user=%s password=%s dbname=%s port=%s sslmode=disable TimeZone=Asia/Shanghai",
		PostgresHost, PostgresUser, PostgresPassword, PostgresDB, PostgresPort)

	var err error

	DB, err = gorm.Open(postgres.Open(DomainSourceName), &gorm.Config{})
	if err != nil {
		log.Fatal("Failed to connect to database", err)
	}

	// Check if the users table exists
	var tableExists bool
	err = DB.Raw("SELECT EXISTS (SELECT FROM pg_tables WHERE tablename = 'users')").Scan(&tableExists).Error
	if err != nil {
		log.Fatal("Failed to check if table exists", err)
	}

	// Only run migrations if the table doesn't exist
	if !tableExists {
		// Create the gender enum type
		err = DB.Exec("CREATE TYPE gender AS ENUM ('male', 'female')").Error
		if err != nil {
			log.Printf("Warning: Failed to create gender enum type: %v", err)
		}

		// Run auto migration
		if err := DB.AutoMigrate(
			&models.User{},
		); err != nil {
			log.Fatal("Failed to migrate models", err)
		}
		log.Println("Database initialized successfully")
	} else {
		log.Println("Database already exists, skipping initialization")
	}
}
