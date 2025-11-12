package group_package

import (
	"backend/config"
	"backend/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

// PUT /admin/package/:id → update package by ID
func UpdatePackage(c *gin.Context) {
	id := c.Param("id")
	var pkg models.Package

	// Check if package exists
	if err := config.DB.First(&pkg, id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Package tidak ditemukan"})
		return
	}

	// Bind input data
	var input struct {
		DestinationID uint    `json:"destinationId"`
		SubPackageID  uint    `json:"subPackageId"`
		Price         float64 `json:"price"`
		Include       string  `json:"include"`
		NotInclude    string  `json:"notinclude"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Update fields
	if input.DestinationID != 0 {
		pkg.DestinationID = input.DestinationID
	}
	if input.SubPackageID != 0 {
		pkg.SubPackageID = input.SubPackageID
	}
	if input.Price != 0 {
		pkg.Price = input.Price
	}
	if input.Include != "" {
		pkg.Include = input.Include
	}
	if input.NotInclude != "" {
		pkg.NotInclude = input.NotInclude
	}

	// Save changes to database
	if err := config.DB.Save(&pkg).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal mengupdate package"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Package berhasil diupdate",
		"data":    pkg,
	})
}