package routes

import (
	"backend/controllers/user/auth"
	"backend/controllers/user/category"
	"backend/controllers/user/destination"
	"backend/controllers/user/event"
	"backend/controllers/user/favorite"
	"backend/controllers/user/review"
	"backend/controllers/user/subcategory"
	"backend/middleware"

	"github.com/gin-gonic/gin"
)

func SetupUserRoutes(r *gin.Engine) {

	// Auth
	r.POST("/user/register", auth.RegisterUser)
	r.POST("/user/login", auth.LoginUser)

	r.GET("/destinations", destination.GetAllDestinationsUser)
	r.GET("/destinations/:id", destination.GetDestinationByIDUser)

	r.GET("/events", event.GetAllEventsUser)
	r.GET("/events/:id", event.GetEventByIDUser)

	r.GET("/categories", category.GetAllCategoriesUser)
	r.GET("/categories/:id", category.GetCategoryByIDUser)

	r.GET("/subcategories", subcategory.GetAllSubcategoriesUser)
	r.GET("/subcategories/:id", subcategory.GetSubcategoryByIDUser)

	r.GET("/review", review.GetReviews)

	user := r.Group("/user",
		middleware.JWTAuthMiddleware(),
		middleware.RoleOnly(1),
	)

	user.GET("/profile", auth.GetProfile)
	user.PUT("/profile", auth.UpdateProfile)

	user.POST("/favorite", favorite.AddFavorite)
	user.GET("/favorite", favorite.GetUserFavorites)
	user.DELETE("/favorite/:destinationId", favorite.DeleteFavorite)

	user.POST("/review", review.AddReview)
	user.DELETE("/review/:id", review.DeleteReview)

	user.POST("/logout", auth.LogoutUser)
}
