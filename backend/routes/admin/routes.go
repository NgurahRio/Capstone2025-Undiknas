package routes

import (
	"backend/controllers/admin/auth"
	"backend/controllers/admin/category"
	"backend/controllers/admin/destination"
	"backend/controllers/admin/event"
	"backend/controllers/admin/facility"
	"backend/controllers/admin/group_package"
	packagess "backend/controllers/admin/packages"
	"backend/controllers/admin/review"
	"backend/controllers/admin/sos"
	"backend/controllers/admin/subcategory"
	"backend/controllers/admin/subpackage"
	"backend/controllers/admin/user"
	"backend/middleware"
	"time"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
)

func SetupRouter() *gin.Engine {
	r := gin.Default()

	r.Use(cors.New(cors.Config{
		AllowAllOrigins:  true,
		AllowMethods:     []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
		AllowHeaders:     []string{"Origin", "Content-Type", "Authorization"},
		ExposeHeaders:    []string{"Content-Length"},
		AllowCredentials: false,
		MaxAge:           12 * time.Hour,
	}))

	r.POST("/admin/login", auth.LoginAdmin)

	admin := r.Group("/admin")
	admin.Use(
		middleware.JWTAuthMiddleware(),
		middleware.RoleOnly(2),
	)

	{
		// user routes
		admin.GET("/users", user.GetAllUsers)
		admin.GET("/users/:id", user.GetUserByID)
		admin.DELETE("/users/:id", user.DeleteUser)

		// SubPackage routes
		admin.POST("/subpackage", subpackage.CreateSubpackage)
		admin.GET("/subpackage", subpackage.GetAllSubpackages)
		admin.GET("/subpackage/:id", subpackage.GetSubpackageByID)
		admin.PUT("/subpackage/:id", subpackage.UpdateSubpackage)
		admin.DELETE("/subpackage/:id", subpackage.DeleteSubpackage)

		// SubCategory routes
		admin.POST("/subcategory", subcategory.CreateSubcategory)
		admin.GET("/subcategory", subcategory.GetAllSubcategories)
		admin.GET("/subcategory/:id", subcategory.GetSubcategoryByID)
		admin.PUT("/subcategory/:id", subcategory.UpdateSubcategory)
		admin.DELETE("/subcategory/:id", subcategory.DeleteSubcategory)

		// Category routes
		admin.POST("/category", category.CreateCategory)
		admin.GET("/category", category.GetAllCategories)
		admin.GET("/category/:id", category.GetCategoryByID)
		admin.PUT("/category/:id", category.UpdateCategory)
		admin.DELETE("/category/:id", category.DeleteCategory)

		// Destination routes
		admin.POST("/destination", destination.CreateDestination)
		admin.GET("/destination", destination.GetAllDestinations)
		admin.GET("/destination/:id", destination.GetDestinationByID)
		admin.PUT("/destination/:id", destination.UpdateDestination)
		admin.DELETE("/destination/:id", destination.DeleteDestination)

		//review routes
		admin.GET("/review", review.GetAllReview)
		admin.GET("/review/:id", review.GetReviewByID)
		admin.DELETE("/review/:id", review.DeleteReview)

		// Package routes
		admin.POST("/package", group_package.CreatePackage)
		admin.GET("/package", group_package.GetAllPackages)
		admin.GET("/package/:id", group_package.GetPackageByID)
		admin.PUT("/package/:id", group_package.UpdatePackage)
		admin.DELETE("/package/:id", group_package.DeletePackage)

		// Event routes
		admin.POST("/event", event.CreateEvent)
		admin.GET("/event", event.GetAllEvents)
		admin.GET("/event/:id", event.GetEventByID)
		admin.PUT("/event/:id", event.UpdateEvent)
		admin.DELETE("/event/:id", event.DeleteEvent)

		// SOS routes
		admin.POST("/sos", sos.CreateSOS)
		admin.GET("/sos", sos.GetAllSOS)
		admin.GET("/sos/:id", sos.GetSOSByID)
		admin.PUT("/sos/:id", sos.UpdateSOS)
		admin.DELETE("/sos/:id", sos.DeleteSOS)

		// Facility routes
		admin.DELETE("/facility/:id", facility.DeleteFacility)
		admin.PUT("/facility/:id", facility.UpdateFacility)
		admin.POST("/facility", facility.CreateFacility)
		admin.GET("/facility", facility.GetAllFacility)
		admin.GET("/facility/:id", facility.GetFacilityByID)

		// Packages routes
		admin.POST("/packages", packagess.CreatePackages)
		admin.GET("/packages", packagess.GetAllPackages)
		admin.GET("/packages/:destinationId", packagess.GetPackageByDestinationID)


	}

	return r
}
