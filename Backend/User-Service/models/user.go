package models

import (
	"golang.org/x/crypto/bcrypt"
	"time"
)

type Gender string

const (
	Male   Gender = "male"
	Female Gender = "female"
)

type User struct {
	ID             uint      `json:"id" gorm:"primary_key"`
	Username       string    `json:"username" gorm:"unique;not null"`
	Firstname      string    `json:"first_name" gorm:"column:first_name"`
	Lastname       string    `json:"last_name" gorm:"column:last_name"`
	DateOfBirth    time.Time `json:"date_of_birth" gorm:"column:date_of_birth;not null"`
	Password       string    `json:"-" gorm:"not null"`
	Email          string    `json:"email" gorm:"unique;not null"`
	ProfilePicture string    `json:"profile_picture" gorm:"not null"`
	Gender         string    `json:"gender"  gorm:"gender('male','female');not null"`
	PublicKey      string    `json:"public_key" gorm:"default:NULL"` //can be null because it will be set once user creation returns userID
	Role           string    `json:"role" gorm:"not null"`
	CreatedAt      time.Time `json:"created_at" gorm:"default:NOW()"`
}

// Set hashed password before saving the new user into database

func (user *User) HashPassword(password string) error {
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)

	if err != nil {
		return err
	}

	user.Password = string(hashedPassword)
	return nil
}

func (user *User) CheckPassword(password string) bool {
	err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(password))
	return err == nil
}
