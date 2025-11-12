package group_package

import (
	"backend/config"
	"backend/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

// DELETE /admin/package/:id → delete package by ID
func DeletePackage(c *gin.Context) {
	id := c.Param("id")
	var pkg models.Package

	// Check if package exists
	if err := config.DB.First(&pkg, id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Package tidak ditemukan"})
		return
	}

	// Delete the package
	if err := config.DB.Delete(&pkg).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal menghapus package"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Berhasil menghapus package",
		"data":    pkg,
	})
}