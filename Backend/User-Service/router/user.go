package router

import (
	"User-Service/config"
	"User-Service/controller"
	"encoding/json"
	"github.com/gin-gonic/gin"
	"net/http"
	"net/url"
	"strings"
)

func SetupRouter() *gin.Engine {

	router := gin.Default()

	publicUserGroup := router.Group("/users")
	{
		publicUserGroup.POST("/register", controller.CreateUser)
		publicUserGroup.GET("/check-username", controller.CheckUserByUsername)
		publicUserGroup.GET("/check-email", controller.CheckEmail)
		publicUserGroup.GET("/get-by-username", controller.GetUserByUsername)
		publicUserGroup.POST("/assign-public-key", controller.AssignPublicKey)
		publicUserGroup.POST("/validate-login", controller.ValidateLogin)
	}

	//Private routes which are only accessible to logged-in users

	private := router.Group("/")
	private.Use(authMiddleware())
	privateUserGroup := private.Group("/users")
	{
		privateUserGroup.POST("/change-password", controller.ChangePassword)
		privateUserGroup.DELETE("/delete", controller.DeleteUser)
	}

	return router
}

func authMiddleware() gin.HandlerFunc {
	return func(context *gin.Context) {
		tokenString := context.GetHeader("Authorization")
		if tokenString == "" || !strings.HasPrefix(tokenString, "Bearer ") {
			context.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "No token provided"})
			context.Abort()
			return
		}
		tokenString = strings.TrimPrefix(tokenString, "Bearer ")

		response, err := http.PostForm(config.AuthServiceURL+"/validate-token", url.Values{"token": {tokenString}})
		if err != nil {
			context.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "Invalid token"})
			context.Abort()
			return
		}

		var data map[string]interface{}
		json.NewDecoder(response.Body).Decode(&data)

		context.Set("userID", data["userID"])
		context.Next()
	}
}
