package service

import (
	"File-Service/config"
	"errors"
	"fmt"
	"mime/multipart"
	"net/url"
	"os"
	"path/filepath"
)

func UploadFile(file *multipart.FileHeader) (string, error) {

	uploadDir := "uploads"

	if _, err := os.Stat(uploadDir); os.IsNotExist(err) {
		err = os.Mkdir(uploadDir, 0755)
		if err != nil {
			return "", errors.New(fmt.Sprint("Error creating upload dir: ", uploadDir))
		}
	}

	filePath := filepath.Join(uploadDir, file.Filename)

	if err := SaveUploadedFile(file, filePath); err != nil {
		return "", fmt.Errorf("Error saving file: %v", err)
	}

	fileURL := fmt.Sprintf(config.FileServeURL+"/uploads/%s", file.Filename)
	return fileURL, nil

}

func SaveUploadedFile(file *multipart.FileHeader, filePath string) error {

	src, err := file.Open()
	if err != nil {
		return errors.New(fmt.Sprint("Error opening uploaded file: ", filePath))
	}
	defer src.Close()

	dst, err := os.Create(filePath)
	if err != nil {
		return errors.New(fmt.Sprint("Error creating uploaded file: ", filePath))
	}

	defer dst.Close()

	_, err = dst.ReadFrom(src)
	return err
}
func DeleteUploadedFile(fileURL string) error {

	parsedURL, err := url.Parse(fileURL)
	if err != nil {
		return errors.New("invalid file URL")
	}

	filePath := "." + parsedURL.Path

	if _, err := os.Stat(filePath); os.IsNotExist(err) {
		return errors.New("file not found")
	}

	if err := os.Remove(filePath); err != nil {
		return err
	}

	return nil
}
