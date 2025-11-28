package group_package

import (
	"backend/config"
	"backend/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

func GetAllPackages(c *gin.Context) {
	var packages []models.Package

	if err := config.DB.Find(&packages).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": "Gagal mengambil data package",
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Berhasil mengambil semua package",
		"data":    packages,
	})
}

func GetPackageByID(c *gin.Context) {
	id := c.Param("id")
	var pkg models.Package

	if err := config.DB.First(&pkg, "id_package = ?", id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{
			"message": "Package tidak ditemukan",
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Berhasil mengambil data package",
		"data":    pkg,
	})
}
