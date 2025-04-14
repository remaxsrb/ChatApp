package service

import (
	"User-Service/config"
	"User-Service/models"
	"errors"
)

func CreateUser(user *models.User) error {

	err := user.HashPassword(user.Password)

	if err != nil {
		return err
	}

	if user.ProfilePicture == "" {
		if user.Gender == "male" {
			user.ProfilePicture = config.ClientFileServeURL + "/uploads/default_male.png"
		}

		if user.Gender == "female" {
			user.ProfilePicture = config.ClientFileServeURL + "/uploads/default_female.jpg"
		}
	}

	user.Role = "user"

	return config.DB.Create(&user).Error
}

func AssignPublicKey(userID uint, publicKey string) error {
	var user models.User

	if err := config.DB.Model(&user).Where("id = ?", userID).Update("public_key", publicKey).Error; err != nil {
		return errors.New("failed to assign public key")
	}

	return nil
}

func GetUserByUsername(username string) (*models.User, error) {
	var user models.User

	if err := config.DB.Where("username = ?", username).First(&user).Error; err != nil {
		return nil, errors.New("user not found")
	}

	return &user, nil
}

func ChangePassword(username string, newPassword string) error {
	var user, err = GetUserByUsername(username)

	if err != nil {
		return err
	}

	err = user.HashPassword(newPassword)

	if err != nil {
		return err
	}

	return config.DB.Save(&user).Error
}

func ChekEmail(email string) error {
	var user models.User
	if err := config.DB.Where("email = ?", email).First(&user).Error; err != nil {
		return errors.New("user not found")
	}
	return nil
}

func DeleteUser(user *models.User) error {
	return config.DB.Delete(&user).Error
}
