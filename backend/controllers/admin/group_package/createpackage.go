package group_package

import (
	"backend/config"
	"backend/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

// POST /admin/package → create new package
func CreatePackage(c *gin.Context) {
	var input struct {
		DestinationID uint    `json:"destinationId" binding:"required"`
		SubPackageID  uint    `json:"subPackageId" binding:"required"`
		Price         float64 `json:"price"`
		Include       string  `json:"include"`
		NotInclude    string  `json:"notinclude"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	pkg := models.Package{
		DestinationID: input.DestinationID,
		SubPackageID:  input.SubPackageID,
		Price:         input.Price,
		Include:       input.Include,
		NotInclude:    input.NotInclude,
	}

	if err := config.DB.Create(&pkg).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal menambahkan package"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Package berhasil ditambahkan",
		"data":    pkg,
	})
}
