package packagess

import (
	"backend/config"
	"backend/models"
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

func UpdatePackages(c *gin.Context) {
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

	var dest models.Destination
	if err := config.DB.First(&dest, "id_destination = ?", destID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"message": "destinationId tidak ditemukan di database"})
		return
	}

	var pkg models.Packages
	if err := config.DB.First(&pkg, "destinationId = ?", destID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{
			"message": "Package untuk destinationId ini belum ada",
		})
		return
	}

	var payload struct {
		SubPackages []struct {
			SubPackageID int `json:"subPackageId"`
			Price        float64
			Include      []struct {
				Image string `json:"image"`
				Name  string `json:"name"`
			} `json:"include"`
		} `json:"subpackages"`
	}

	if err := c.ShouldBindJSON(&payload); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"message": "Payload tidak valid, pastikan format JSON benar",
		})
		return
	}

	if len(payload.SubPackages) == 0 {
		c.JSON(http.StatusBadRequest, gin.H{"message": "subpackages tidak boleh kosong"})
		return
	}

	updatedData := map[string]subPackageDetail{}

	for idx, item := range payload.SubPackages {
		if item.SubPackageID == 0 {
			c.JSON(http.StatusBadRequest, gin.H{
				"message": fmt.Sprintf("subPackageId wajib diisi pada index %d", idx),
			})
			return
		}

		if item.Price < 0 {
			c.JSON(http.StatusBadRequest, gin.H{
				"message": fmt.Sprintf("Harga tidak boleh kurang dari 0 pada index %d", idx),
			})
			return
		}

		var sub models.SubPackage
		if err := config.DB.First(&sub, "id_subpackage = ?", item.SubPackageID).Error; err != nil {
			c.JSON(http.StatusBadRequest, gin.H{
				"message": fmt.Sprintf("subPackageId %d tidak ditemukan di tabel subpackage", item.SubPackageID),
			})
			return
		}

		if len(item.Include) == 0 {
			c.JSON(http.StatusBadRequest, gin.H{
				"message": fmt.Sprintf("Include wajib diisi untuk subPackageId %d", item.SubPackageID),
			})
			return
		}

		detail := subPackageDetail{
			Price:   item.Price,
			Include: []subPackageInclude{},
		}

		for incIdx, inc := range item.Include {
			if inc.Image == "" {
				c.JSON(http.StatusBadRequest, gin.H{
					"message": fmt.Sprintf("Image wajib diisi pada include index %d untuk subPackageId %d", incIdx, item.SubPackageID),
				})
				return
			}

			nameVal := inc.Name
			if nameVal == "" {
				nameVal = sub.Packagetype
			}

			detail.Include = append(detail.Include, subPackageInclude{
				Image: inc.Image,
				Name:  nameVal,
			})
		}

		updatedData[strconv.Itoa(item.SubPackageID)] = detail
	}

	jsonBytes, _ := json.MarshalIndent(updatedData, "", "  ")
	pkg.SubPackageData = string(jsonBytes)

	if err := config.DB.Save(&pkg).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": "Gagal mengupdate package",
			"error":   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Package berhasil diupdate",
		"data": gin.H{
			"id_packages":     pkg.ID,
			"destinationId":   pkg.DestinationID,
			"subpackage_data": updatedData,
		},
	})
}
