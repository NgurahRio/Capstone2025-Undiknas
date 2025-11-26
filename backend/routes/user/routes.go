package routes

import (
	"backend/controllers/user/auth"
	"backend/middleware"

	"github.com/gin-gonic/gin"
)

// SetupUserRoutes registers user-related routes on the provided engine.
func SetupUserRoutes(r *gin.Engine) {
    // Public registration
    r.POST("/user/register", auth.RegisterUser)

    // Public login
    r.POST("/user/login", auth.LoginUser)

    // Logout requires a valid (non-blacklisted) token
    r.POST("/user/logout", middleware.JWTAuthMiddleware(), auth.LogoutUser)
}
