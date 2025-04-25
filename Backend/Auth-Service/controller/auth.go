package controller

import (
	"Auth-Service/service"
	"github.com/gin-gonic/gin"
	"net/http"
)

func Login(context *gin.Context) {

	var loginData struct {
		Username string `json:"username"`
		Password string `json:"password"`
	}

	if err := context.ShouldBindJSON(&loginData); err != nil {
		context.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	token, err := service.Login(loginData.Username, loginData.Password)
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
