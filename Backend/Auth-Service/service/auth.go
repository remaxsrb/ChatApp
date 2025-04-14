package service

import (
	"Auth-Service/config"
	"Auth-Service/utils"
	"errors"
	"github.com/golang-jwt/jwt/v5"
	"net/http"
	"net/url"
)

type Claims struct {
	UserID   string `json:"userID"`
	Username string `json:"username"`
	jwt.RegisteredClaims
}

func Login(username, password string) (string, error) {
	//Send a post request to user service in order to validate login data

	response, err := http.PostForm(config.UserServiceURL, url.Values{"username": {username}, "password": {password}})
	if err != nil || response.StatusCode != http.StatusOK {
		return "", err
	}

	token, err := utils.GenerateJWT(username)
	if err != nil {
		return "", err
	}

	return token, nil

}

func ValidateToken(tokenString string) (*Claims, error) {
	token, err := jwt.ParseWithClaims(tokenString, &Claims{}, func(token *jwt.Token) (interface{}, error) {
		return []byte(config.JWTSecret), nil
	})

	if err != nil {
		return nil, err
	}

	claims, ok := token.Claims.(*Claims)
	if !ok || !token.Valid {
		return nil, errors.New("invalid token")
	}

	return claims, nil
}
