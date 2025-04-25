package controller

import (
	"User-Service/config"
	"User-Service/models"
	"User-Service/service"
	"github.com/gin-gonic/gin"
	"log"
	"net/http"
	"net/url"
)

func CreateUser(context *gin.Context) {
	var req models.RegisterRequest

	if err := context.ShouldBindJSON(&req); err != nil {
		context.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	user := models.User{
		Username:       req.Username,
		Password:       req.Password,
		DateOfBirth:    req.DateOfBirth,
		Gender:         req.Gender,
		ProfilePicture: req.ProfilePicture,
		Email:          req.Email,
	}

	if err := service.CreateUser(&user); err != nil {
		log.Println("Error binding JSON:", err)
		context.JSON(http.StatusInternalServerError, gin.H{"error": "Could not create user"})
		return
	}

	user.Password = ""
	context.JSON(http.StatusCreated, gin.H{"userID": user.ID})
}

func AssignPublicKey(context *gin.Context) {
	var updateData struct {
		PublicKey string `json:"public_key"`
		UserID    uint   `json:"userID"`
	}

	if err := context.ShouldBindJSON(&updateData); err != nil {
		context.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := service.AssignPublicKey(updateData.UserID, updateData.PublicKey); err != nil {
		context.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	context.JSON(http.StatusOK, gin.H{"Status": "Success"})

}

func ChangePassword(context *gin.Context) {

	var passwordChangeData struct {
		Username    string `json:"username"`
		NewPassword string `json:"newPassword"`
	}

	if err := context.ShouldBindJSON(&passwordChangeData); err != nil {
		context.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := service.ChangePassword(passwordChangeData.Username, passwordChangeData.NewPassword); err != nil {
		context.JSON(http.StatusInternalServerError, gin.H{"error": "Could not change password"})
		return
	}

	context.JSON(http.StatusOK, gin.H{"message": "Password changed successfully"})

}

func DeleteUser(context *gin.Context) {

	var reqData struct {
		Username string `json:"username"`
	}
	if err := context.ShouldBindJSON(&reqData); err != nil {
		context.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	//request to file service to delete profile photo

	user, err := service.GetUserByUsername(reqData.Username)
	if err != nil {
		context.JSON(http.StatusInternalServerError, gin.H{"error": "No user found"})
		return
	}

	_, err = http.PostForm(config.FileServiceURL+"/delete", url.Values{"fileURL": {user.ProfilePicture}})

	if err != nil {
		context.JSON(http.StatusInternalServerError, gin.H{"error": "Could not delete profile picture"})
		return
	}

	if err := service.DeleteUser(user); err != nil {
		context.JSON(http.StatusInternalServerError, gin.H{"error": "Could not delete user"})
		return
	}

	context.JSON(http.StatusOK, gin.H{"message": "User deleted successfully"})

}

func GetUserByUsername(context *gin.Context) {

	var username = context.Query("username")
	user, err := service.GetUserByUsername(username)
	if err != nil {
		context.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		return
	}

	context.JSON(http.StatusOK, gin.H{"user": user})
}

func CheckUserByUsername(context *gin.Context) {

	var username = context.Query("username")
	_, err := service.GetUserByUsername(username)
	if err != nil {
		context.JSON(http.StatusOK, gin.H{"in_db": false})
		return
	}

	context.JSON(http.StatusConflict, gin.H{"in_db": username, "exists": true})
}

func CheckEmail(context *gin.Context) {
	var email = context.Query("email")
	err := service.ChekEmail(email)
	if err != nil {
		context.JSON(http.StatusOK, gin.H{"in_db": false})
		return
	}
	context.JSON(http.StatusConflict, gin.H{"in_db": true})
}

func ValidateLogin(context *gin.Context) {
	username := context.PostForm("username")
	password := context.PostForm("password")

	user, err := service.GetUserByUsername(username)
	if err != nil {
		context.JSON(http.StatusNotFound, gin.H{"error": "Invalid username"})
		return
	}

	if !user.CheckPassword(password) {
		context.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid password"})
		return
	}

	context.JSON(http.StatusOK, gin.H{"username": user.Username, "password": user.Password})
}
