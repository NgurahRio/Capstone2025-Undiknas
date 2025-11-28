package group_package

import (
	"backend/config"
	"backend/models"
	"fmt"
	"net/http"

	"github.com/gin-gonic/gin"
)

func CreatePackage(c *gin.Context) {
	var input struct {
		DestinationID uint    `json:"destinationId" binding:"required"`
		SubPackageID  uint    `json:"subPackageId" binding:"required"`
		Price         float64 `json:"price"`
		Include       string  `json:"include"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"message": "Input tidak valid",
		})
		return
	}

	var dest models.Destination
	if err := config.DB.First(&dest, "id_destination = ?", input.DestinationID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{
			"message": fmt.Sprintf("Destination dengan ID %d tidak ditemukan", input.DestinationID),
		})
		return
	}

	var sub models.SubPackage
	if err := config.DB.First(&sub, "id_subpackage = ?", input.SubPackageID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{
			"message": fmt.Sprintf("Subpackage dengan ID %d tidak ditemukan", input.SubPackageID),
		})
		return
	}
	
	pkg := models.Package{
		DestinationID: input.DestinationID,
		SubPackageID:  input.SubPackageID,
		Price:         input.Price,
		Include:       input.Include,
	}

	if err := config.DB.Create(&pkg).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": "Gagal menambahkan package",
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Package berhasil ditambahkan",
		"data": gin.H{
			"id_package":    pkg.ID,
			"destinationId": pkg.DestinationID,
			"subPackageId":  pkg.SubPackageID,
			"price":         pkg.Price,
			"include":       pkg.Include,
		},
	})
}
