package group_package

import (
	"backend/config"
	"backend/models"
	"fmt"
	"net/http"

	"github.com/gin-gonic/gin"
)

func UpdatePackage(c *gin.Context) {
	id := c.Param("id")
	var pkg models.Package

	if err := config.DB.First(&pkg, "id_package = ?", id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{
			"message": "Package tidak ditemukan",
		})
		return
	}

	var input struct {
		DestinationID uint    `json:"destinationId"`
		SubPackageID  uint    `json:"subPackageId"`
		Price         float64 `json:"price"`
		Include       string  `json:"include"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"message": "Input tidak valid",
		})
		return
	}

	updated := gin.H{}

	if input.DestinationID != 0 {
		var dest models.Destination
		if err := config.DB.First(&dest, "id_destination = ?", input.DestinationID).Error; err != nil {
			c.JSON(http.StatusNotFound, gin.H{
				"message": fmt.Sprintf("Destination dengan ID %d tidak ditemukan", input.DestinationID),
			})
			return
		}
		pkg.DestinationID = input.DestinationID
		updated["destinationId"] = input.DestinationID
	}

	if input.SubPackageID != 0 {
		var sub models.SubPackage
		if err := config.DB.First(&sub, "id_subpackage = ?", input.SubPackageID).Error; err != nil {
			c.JSON(http.StatusNotFound, gin.H{
				"message": fmt.Sprintf("Subpackage dengan ID %d tidak ditemukan", input.SubPackageID),
			})
			return
		}
		pkg.SubPackageID = input.SubPackageID
		updated["subPackageId"] = input.SubPackageID
	}

	if input.Price != 0 {
		pkg.Price = input.Price
		updated["price"] = input.Price
	}

	if input.Include != "" {
		pkg.Include = input.Include
		updated["include"] = input.Include
	}

	if err := config.DB.Save(&pkg).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": "Gagal mengupdate package",
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Package berhasil diupdate",
		"data":    updated,
	})
}
