package middleware

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func RoleIDAuthorization(requiredRole uint) gin.HandlerFunc {
	return func(c *gin.Context) {

		roleIDValue, exists := c.Get("role_id")
		if !exists {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Role not found in token"})
			c.Abort()
			return
		}

		var roleID uint

		switch v := roleIDValue.(type) {
		case float64:
			roleID = uint(v)
		case uint:
			roleID = v
		case int:
			roleID = uint(v)
		default:
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid role type"})
			c.Abort()
			return
		}

		if roleID != requiredRole {
			c.JSON(http.StatusForbidden, gin.H{"error": "Access denied (not admin)"})
			c.Abort()
			return
		}

		c.Next()
	}
}
