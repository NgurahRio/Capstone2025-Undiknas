package routes

import (
	"backend/controllers/admin/user"
	"backend/middleware"

	"github.com/gin-gonic/gin"
)

func AdminRoutes(r *gin.Engine) {
	// Group route khusus admin
	adminRoutes := r.Group("/admin")
	adminRoutes.Use(middleware.JWTAuthMiddleware(), middleware.RoleIDAuthorization(2)) // 2 = admin
	{
		// GET semua user
		adminRoutes.GET("/users", user.GetAllUsers)

		// GET user berdasarkan ID
		adminRoutes.GET("/users/:id", user.GetUserByID)
	}
}