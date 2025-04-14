package router

import (
	"Auth-Service/controller"
	"github.com/gin-gonic/gin"
)

func SetupRouter() *gin.Engine {
	router := gin.Default()

	authGroup := router.Group("/auth")
	{
		authGroup.POST("login", controller.Login)
		authGroup.POST("validate-token", controller.ValidateToken)
	}

	return router
}
