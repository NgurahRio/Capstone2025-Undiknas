package category

import (
	"backend/config"
	"backend/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

// DELETE /admin/category/:id → delete category by ID
func DeleteCategory(c *gin.Context) {
	id := c.Param("id")
	var category models.Category

	// Check if category exists
	if err := config.DB.First(&category, id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Category tidak ditemukan"})
		return
	}

	// Delete the category
	if err := config.DB.Delete(&category).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal menghapus category"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Berhasil menghapus category",
		"data":    category,
	})
}