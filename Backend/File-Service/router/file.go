package router

import (
	"File-Service/controller"
	"github.com/gin-gonic/gin"
)

func SetupRouter() *gin.Engine {
	router := gin.Default()

	fileGroup := router.Group("/file")
	{
		fileGroup.POST("/upload", controller.UploadFile)
		fileGroup.DELETE("/delete", controller.DeleteFile)
	}

	return router
}
