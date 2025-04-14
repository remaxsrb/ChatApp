package router

import "github.com/gin-gonic/gin"

func SetupRouter() *gin.Engine {
	router := gin.Default()

	router.Static("/uploads", "./uploads") //static file serving

	return router
}
