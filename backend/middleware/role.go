package middleware

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

// RoleIDAuthorization memeriksa apakah role_id dari token sesuai dengan allowed ID
func RoleIDAuthorization(allowedIDs ...int) gin.HandlerFunc {
	return func(c *gin.Context) {
		roleIDValue, exists := c.Get("role_id")
		if !exists {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Role ID tidak ditemukan di token"})
			c.Abort()
			return
		}

		// JWT claims disimpan sebagai float64, jadi perlu dikonversi
		roleID := int(roleIDValue.(float64))

		for _, allowed := range allowedIDs {
			if roleID == allowed {
				c.Next()
				return
			}
		}

		c.JSON(http.StatusForbidden, gin.H{"error": "Akses ditolak, bukan admin"})
		c.Abort()
	}
}
