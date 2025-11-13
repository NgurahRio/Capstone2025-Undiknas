package sos

import (
	"backend/config"
	"backend/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

func DeleteSOS(c *gin.Context) {
	id := c.Param("id")

	var sos models.SOS

	if err := config.DB.First(&sos, id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "SOS tidak ditemukan"})
		return
	}

	if err := config.DB.Delete(&sos).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal menghapus SOS"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "SOS berhasil dihapus",
		"data":    sos,
	})
}
