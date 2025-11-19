package middleware

import (
	"os"
	"time"

	"github.com/golang-jwt/jwt/v5"
)

var secretKey = []byte(os.Getenv("SECRET_KEY"))

type TokenPayload struct {
	UserID uint
	RoleID uint
}

func GenerateToken(userID uint, roleID uint) (string, error) {

	claims := jwt.MapClaims{
		"user_id": userID,
		"role_id": roleID,
		"exp":     time.Now().Add(24 * time.Hour).Unix(),
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	return token.SignedString(secretKey)
}

func ValidateToken(tokenStr string) (*TokenPayload, error) {

	token, err := jwt.Parse(tokenStr, func(t *jwt.Token) (interface{}, error) {
		return secretKey, nil
	})

	if err != nil || !token.Valid {
		return nil, err
	}

	claims := token.Claims.(jwt.MapClaims)

	userID := uint(claims["user_id"].(float64))
	roleID := uint(claims["role_id"].(float64))

	return &TokenPayload{
		UserID: userID,
		RoleID: roleID,
	}, nil
}
