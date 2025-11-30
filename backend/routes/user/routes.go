package routes

import (
	"backend/controllers/user/auth"
	"backend/controllers/user/destination"
	"backend/controllers/user/event"
	userfav "backend/controllers/user/favorite"
	"backend/controllers/user/review"
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

	// Reviews
	user.POST("/review", review.AddReview)
	user.GET("/review", review.GetReviews)
	user.PUT("/review/:id", review.UpdateReview)
	user.DELETE("/review/:id", review.DeleteReview)

	// Events
	user.GET("/events", event.GetAllEventsUser)
	user.GET("/events/:id", event.GetEventByIDUser)
}
