package controller

import (
	"File-Service/service"
	"github.com/gin-gonic/gin"
	"net/http"
)

func UploadFile(context *gin.Context) {

	file, err := context.FormFile("file")
	if err != nil {
		context.JSON(http.StatusBadRequest, gin.H{"error": "No file found"})
		return
	}

	fileURL, err := service.UploadFile(file)
	if err != nil {
		context.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	context.JSON(http.StatusOK, gin.H{
		"message": "File uploaded successfully",
		"fileURL": fileURL,
	})

}

func DeleteFile(context *gin.Context) {
	file := context.PostForm("fileURL")

	err := service.DeleteUploadedFile(file)
	if err != nil {
		context.JSON(http.StatusBadRequest, gin.H{"error": "File delete failed"})
		return
	}

	context.JSON(http.StatusOK, gin.H{"message": "File deleted successfully"})
}
