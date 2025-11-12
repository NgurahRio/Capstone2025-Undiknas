package subpackage

import (
	"backend/config"
	"backend/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

// PUT /admin/subpackage/:id → update subpackage by ID
func UpdateSubpackage(c *gin.Context) {
	id := c.Param("id")
	var subpackage models.SubPackage

	// Check if subpackage exists
	if err := config.DB.First(&subpackage, id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Subpackage tidak ditemukan"})
		return
	}

	// Bind input data
	var input struct {
		JenisPackage string `json:"jenispackage"`
		Image        []byte `json:"image"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Update fields
	if input.JenisPackage != "" {
		subpackage.Packagetype = input.JenisPackage
	}
	if input.Image != nil {
		subpackage.Image = input.Image
	}

	// Save changes to database
	if err := config.DB.Save(&subpackage).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal mengupdate subpackage"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Subpackage berhasil diupdate",
		"data":    subpackage,
	})
}