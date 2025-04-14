package controller

import (
	"Auth-Service/service"
	"github.com/gin-gonic/gin"
	"net/http"
)

func Login(context *gin.Context) {
	username := context.PostForm("username")
	password := context.PostForm("password")

	token, err := service.Login(username, password)
	if err != nil {
		context.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
		return
	}

	context.JSON(http.StatusOK, gin.H{"token": token})
}

func ValidateToken(context *gin.Context) {
	tokenString := context.PostForm("token")

	claims, err := service.ValidateToken(tokenString)
	if err != nil {
		context.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid token"})
		return
	}

	context.JSON(http.StatusOK, gin.H{
		"message": "Token is valid",
		"userID":  claims.UserID,
	})
}
