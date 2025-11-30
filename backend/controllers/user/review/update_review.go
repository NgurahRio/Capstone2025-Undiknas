package review

import (
	"backend/config"
	"backend/models"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

// UpdateReview memperbarui rating atau komentar milik user pada review tertentu.
func UpdateReview(c *gin.Context) {
	reviewIDStr := c.Param("id")
	reviewID, err := strconv.ParseUint(reviewIDStr, 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "ID review tidak valid"})
		return
	}

	userID, ok := getUserID(c)
	if !ok {
		return
	}

	var review models.Review
	if err := config.DB.Where("id_review = ? AND userId = ?", reviewID, userID).First(&review).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Review tidak ditemukan atau bukan milik anda"})
		return
	}

	var input struct {
		Rating  *int   `json:"rating"`
		Comment *string `json:"comment"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Permintaan tidak valid"})
		return
	}

	if input.Rating == nil && input.Comment == nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Tidak ada data yang diperbarui"})
		return
	}

	if input.Rating != nil {
		if *input.Rating < 1 || *input.Rating > 5 {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Rating harus antara 1 sampai 5"})
			return
		}
		review.Rating = *input.Rating
	}

	if input.Comment != nil {
		review.Comment = *input.Comment
	}

	if err := config.DB.Save(&review).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal memperbarui review"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Review berhasil diperbarui",
		"data":    review,
	})
}
