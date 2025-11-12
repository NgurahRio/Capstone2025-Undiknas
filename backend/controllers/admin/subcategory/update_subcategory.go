package subcategory

import (
	"backend/config"
	"backend/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

// PUT /admin/subcategory/:id → update subcategory by ID
func UpdateSubcategory(c *gin.Context) {
	id := c.Param("id")
	var subcategory models.Subcategory

	// Check if subcategory exists
	if err := config.DB.First(&subcategory, id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Subcategory tidak ditemukan"})
		return
	}

	// Bind input data
	var input struct {
		CategoryID uint   `json:"categoriesId"`
		Name       string `json:"namesubcategories"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Update fields
	if input.CategoryID != 0 {
		subcategory.CategoryID = input.CategoryID
	}
	if input.Name != "" {
		subcategory.Name = input.Name
	}

	// Save changes to database
	if err := config.DB.Save(&subcategory).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal mengupdate subcategory"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Subcategory berhasil diupdate",
		"data":    subcategory,
	})
}