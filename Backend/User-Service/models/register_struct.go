package models

import "time"

type RegisterRequest struct {
	Username       string    `json:"username" binding:"required"`
	Email          string    `json:"email" binding:"required,email"`
	Password       string    `json:"password" binding:"required"`
	DateOfBirth    time.Time `json:"date_of_birth" binding:"required"`
	Gender         string    `json:"gender" binding:"required,oneof=male female"`
	ProfilePicture string    `json:"profile_picture"`
}
