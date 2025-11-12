package subpackage

import (
	"backend/config"
	"backend/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

// ✅ CREATE subpackage
func CreateSubpackage(c *gin.Context) {
	var input struct {
		JenisPackage string `json:"jenispackage" binding:"required"`
		Image        []byte `json:"image"` // opsional
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	subpackage := models.SubPackage{
		Packagetype: input.JenisPackage,
		Image:       input.Image,
	}

	if err := config.DB.Create(&subpackage).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal menambahkan subpackage"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Subpackage berhasil ditambahkan",
		"data":    subpackage,
	})
}
