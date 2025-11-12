package destination

import (
	"net/http"
	"backend/config"
	"backend/models"

	"github.com/gin-gonic/gin"
)

// ✅ GET semua destinasi
func GetAllDestinations(c *gin.Context) {
	var destinations []models.Destination

	if err := config.DB.Find(&destinations).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal mengambil data destinasi"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Berhasil mengambil semua destinasi",
		"data":    destinations,
	})
}

// ✅ GET destinasi berdasarkan ID
func GetDestinationByID(c *gin.Context) {
	id := c.Param("id")
	var destination models.Destination

	if err := config.DB.First(&destination, id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Destinasi tidak ditemukan"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Berhasil mengambil data destinasi",
		"data":    destination,
	})
}
