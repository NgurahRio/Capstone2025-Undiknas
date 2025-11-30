package routes

import (
	"backend/controllers/user/auth"
	userfav "backend/controllers/user/favorite"
	"backend/middleware"

	"github.com/gin-gonic/gin"
)

// SetupUserRoutes registers user-related routes on the provided engine.
func SetupUserRoutes(r *gin.Engine) {
    // Public registration
    r.POST("/user/register", auth.RegisterUser)

    // Public login
    r.POST("/user/login", auth.LoginUser)

    // Favorites (requires auth)
    r.POST("/user/favorite", middleware.JWTAuthMiddleware(), userfav.AddFavorite)
    r.GET("/user/favorite", middleware.JWTAuthMiddleware(), userfav.GetUserFavorites)
    r.DELETE("/user/favorite/:destinationId", middleware.JWTAuthMiddleware(), userfav.DeleteFavorite)

    // Profile
    r.PUT("/user/profile", middleware.JWTAuthMiddleware(), auth.UpdateProfile)

    // Logout requires a valid (non-blacklisted) token
    r.POST("/user/logout", middleware.JWTAuthMiddleware(), auth.LogoutUser)
}
