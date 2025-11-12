package routes

import (
	"backend/controllers/admin/group_package"
	"backend/controllers/admin/review"
	"backend/controllers/admin/subcategory"
	"backend/controllers/admin/subpackage"
	"backend/controllers/admin/user"
	"backend/middleware"

	"github.com/gin-gonic/gin"
)

func AdminRoutes(r *gin.Engine) {
	// Group route khusus admin
	adminRoutes := r.Group("/admin")
	adminRoutes.Use(middleware.JWTAuthMiddleware(), middleware.RoleIDAuthorization(2)) // 2 = admin
	{
		// user routes
		adminRoutes.GET("/users", user.GetAllUsers)
		adminRoutes.GET("/users/:id", user.GetUserByID)
		adminRoutes.DELETE("/users/:id", user.DeleteUser)

		// SubPackage routes
		adminRoutes.POST("/subpackage", subpackage.CreateSubpackage)
		adminRoutes.GET("/subpackage", subpackage.GetAllSubpackages)
		adminRoutes.GET("/subpackage/:id", subpackage.GetSubpackageByID)
		adminRoutes.PUT("/subpackage/:id", subpackage.UpdateSubpackage)
		adminRoutes.DELETE("/subpackage/:id", subpackage.DeleteSubpackage)

		// SubCategory routes
		adminRoutes.POST("/subcategory", subcategory.CreateSubcategory)
		adminRoutes.GET("/subcategory", subcategory.GetAllSubcategories)
		adminRoutes.GET("/subcategory/:id", subcategory.GetSubcategoryByID)
		adminRoutes.PUT("/subcategory/:id", subcategory.UpdateSubcategory)
		adminRoutes.DELETE("/subcategory/:id", subcategory.DeleteSubcategory)

		//review routes
		adminRoutes.GET("/review", review.GetAllReview)
		adminRoutes.GET("/review/:id", review.GetReviewByID)
		adminRoutes.DELETE("/review/:id", review.DeleteReview)

		// Package routes
		adminRoutes.POST("/package", group_package.CreatePackage)
		adminRoutes.GET("/package", group_package.GetAllPackages)
		adminRoutes.GET("/package/:id", group_package.GetPackageByID)
		adminRoutes.PUT("/package/:id", group_package.UpdatePackage)
		adminRoutes.DELETE("/package/:id", group_package.DeletePackage)

	}
}
