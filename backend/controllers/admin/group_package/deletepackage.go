package group_package

import (
	"backend/config"
	"backend/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

func DeletePackage(c *gin.Context) {
	id := c.Param("id")
	var pkg models.Package

	if err := config.DB.First(&pkg, "id_package = ?", id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{
			"message": "Package tidak ditemukan",
		})
		return
	}

	if err := config.DB.Delete(&pkg).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": "Gagal menghapus package",
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Package berhasil dihapus",
	})
}
