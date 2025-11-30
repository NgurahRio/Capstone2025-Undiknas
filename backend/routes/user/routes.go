package routes

import (
	"backend/controllers/user/auth"
	"backend/controllers/user/destination"
	userfav "backend/controllers/user/favorite"
	"backend/middleware"

	"github.com/gin-gonic/gin"
)

func SetupUserRoutes(r *gin.Engine) {

	r.POST("/user/register", auth.RegisterUser)
	r.POST("/user/login", auth.LoginUser)

	user := r.Group("/user",
		middleware.JWTAuthMiddleware(),
		middleware.RoleOnly(1),
	)

	// Favorites
	user.POST("/favorite", userfav.AddFavorite)
	user.GET("/favorite", userfav.GetUserFavorites)
	user.DELETE("/favorite/:destinationId", userfav.DeleteFavorite)

	// Profile
	user.PUT("/profile", auth.UpdateProfile)

	// Logout
	user.POST("/logout", auth.LogoutUser)

	// Destinations
	user.GET("/destinations", destination.GetAllDestinationsUser)
	user.GET("/destinations/:id", destination.GetDestinationByIDUser)
}
