package subpackage

import (
	"backend/config"
	"backend/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

// DELETE /admin/subpackage/:id → delete subpackage by ID
func DeleteSubpackage(c *gin.Context) {
	id := c.Param("id")
	var subpackage models.SubPackage

	// Check if subpackage exists
	if err := config.DB.First(&subpackage, id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Subpackage tidak ditemukan"})
		return
	}

	// Delete the subpackage
	if err := config.DB.Delete(&subpackage).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal menghapus subpackage"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Berhasil menghapus subpackage",
		"data":    subpackage,
	})
}