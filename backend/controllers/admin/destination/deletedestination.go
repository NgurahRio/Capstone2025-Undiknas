package destination

import (
	"net/http"
	"backend/config"
	"backend/models"

	"github.com/gin-gonic/gin"
)

// ✅ DELETE destinasi
func DeleteDestination(c *gin.Context) {
	id := c.Param("id")
	var destination models.Destination

	if err := config.DB.First(&destination, id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Destinasi tidak ditemukan"})
		return
	}

	if err := config.DB.Delete(&destination).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal menghapus destinasi"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Destinasi berhasil dihapus",
	})
}