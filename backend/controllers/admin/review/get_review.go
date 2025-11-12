package review

import (
	"backend/config"
	"backend/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

// ✅ GET semua review
func GetAllReviews(c *gin.Context) {
	var reviews []models.Review

	if err := config.DB.Find(&reviews).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal mengambil data review"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Berhasil mengambil semua review",
		"data":    reviews,
	})
}

// ✅ GET review by ID
func GetReviewByID(c *gin.Context) {
	id := c.Param("id")
	var review models.Review

	if err := config.DB.First(&review, id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Review tidak ditemukan"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Berhasil mengambil data review",
		"data":    review,
	})
}
