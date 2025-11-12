package category

import (
	"backend/config"
	"backend/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

// PUT /admin/category/:id → update category by ID
func UpdateCategory(c *gin.Context) {
	id := c.Param("id")
	var category models.Category

	// Check if category exists
	if err := config.DB.First(&category, id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Category tidak ditemukan"})
		return
	}

	// Bind input data
	var input struct {
		Name string `json:"name"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Update fields
	if input.Name != "" {
		category.Name = input.Name
	}

	// Save changes to database
	if err := config.DB.Save(&category).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal mengupdate category"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Category berhasil diupdate",
		"data":    category,
	})
}