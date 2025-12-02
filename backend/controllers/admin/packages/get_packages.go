package packagess

import (
	"backend/config"
	"backend/models"
	"encoding/json"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

// ======================================================
// GET ALL PACKAGES
// GET /packages
// ======================================================
func GetAllPackages(c *gin.Context) {
	var pkgs []models.Packages

	if err := config.DB.Find(&pkgs).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": "Gagal mengambil semua packages",
		})
		return
	}

	// Parse SubPackageData ke JSON map
	result := []gin.H{}

	for _, pkg := range pkgs {
		var subData map[string]interface{}
		if pkg.SubPackageData != "" {
			json.Unmarshal([]byte(pkg.SubPackageData), &subData)
		}

		result = append(result, gin.H{
			"id_packages":     pkg.ID,
			"destinationId":   pkg.DestinationID,
			"subpackage_data": subData,
		})
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Berhasil mengambil semua packages",
		"data":    result,
	})
}

// ======================================================
// GET PACKAGE BY DESTINATION ID
// GET /packages/:destinationId
// ======================================================
func GetPackageByDestinationID(c *gin.Context) {
	destIDStr := c.Param("destinationId")
	if destIDStr == "" {
		c.JSON(http.StatusBadRequest, gin.H{"message": "destinationId wajib diisi"})
		return
	}

	destID, convErr := strconv.Atoi(destIDStr)
	if convErr != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": "destinationId harus berupa angka"})
		return
	}

	// Pastikan destination ada
	var dest models.Destination
	if err := config.DB.First(&dest, "id_destination = ?", destID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"message": "destinationId tidak ditemukan di database"})
		return
	}

	// Ambil packages
	var pkg models.Packages
	if err := config.DB.First(&pkg, "destinationId = ?", destID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"message": "Package untuk destinationId ini belum ada"})
		return
	}

	// Parse subPackageData
	type subPackageDetail struct {
		Price float64 `json:"price"`
		Image string  `json:"image"`
	}

	subData := map[string]subPackageDetail{}
	if pkg.SubPackageData != "" {
		if err := json.Unmarshal([]byte(pkg.SubPackageData), &subData); err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{
				"message": "Data subpackage rusak / tidak bisa dibaca",
				"error":   err.Error(),
			})
			return
		}
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Berhasil mengambil data package",
		"data": gin.H{
			"id_packages":     pkg.ID,
			"destinationId":   pkg.DestinationID,
			"subpackage_data": subData,
		},
	})
}
