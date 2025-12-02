package packagess

import (
	"backend/config"
	"backend/models"
	"encoding/json"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

func GetAllPackages(c *gin.Context) {
	var pkgs []models.Packages

	if err := config.DB.Find(&pkgs).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": "Gagal mengambil semua packages",
		})
		return
	}

	result := []gin.H{}

	type subPackageDetail struct {
		Price       float64 `json:"price"`
		Image       string  `json:"image"`
		Packagetype string  `json:"packagetype,omitempty"`
	}

	subIDs := map[uint]struct{}{}

	for _, pkg := range pkgs {
		subData := map[string]subPackageDetail{}
		if pkg.SubPackageData != "" {
			json.Unmarshal([]byte(pkg.SubPackageData), &subData)
		}

		for subIDStr := range subData {
			if subIDUint, err := strconv.Atoi(subIDStr); err == nil {
				subIDs[uint(subIDUint)] = struct{}{}
			}
		}
	}

	subTypeByID := map[string]string{}
	if len(subIDs) > 0 {
		ids := make([]uint, 0, len(subIDs))
		for id := range subIDs {
			ids = append(ids, id)
		}

		var subs []models.SubPackage
		if err := config.DB.Where("id_subpackage IN ?", ids).Find(&subs).Error; err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{
				"message": "Gagal mengambil data subpackage",
				"error":   err.Error(),
			})
			return
		}

		for _, sub := range subs {
			subTypeByID[strconv.Itoa(int(sub.ID))] = sub.Packagetype
		}
	}

	for _, pkg := range pkgs {
		subData := map[string]subPackageDetail{}
		if pkg.SubPackageData != "" {
			json.Unmarshal([]byte(pkg.SubPackageData), &subData)
		}

		for subID := range subData {
			if packType, ok := subTypeByID[subID]; ok {
				detail := subData[subID]
				detail.Packagetype = packType
				subData[subID] = detail
			}
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

	var dest models.Destination
	if err := config.DB.First(&dest, "id_destination = ?", destID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"message": "destinationId tidak ditemukan di database"})
		return
	}

	var pkg models.Packages
	if err := config.DB.First(&pkg, "destinationId = ?", destID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"message": "Package untuk destinationId ini belum ada"})
		return
	}

	type subPackageDetail struct {
		Price       float64 `json:"price"`
		Image       string  `json:"image"`
		Packagetype string  `json:"packagetype,omitempty"`
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

	subIDs := []uint{}
	for subIDStr := range subData {
		if subIDUint, err := strconv.Atoi(subIDStr); err == nil {
			subIDs = append(subIDs, uint(subIDUint))
		}
	}

	if len(subIDs) > 0 {
		var subs []models.SubPackage
		if err := config.DB.Where("id_subpackage IN ?", subIDs).Find(&subs).Error; err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{
				"message": "Gagal mengambil data subpackage",
				"error":   err.Error(),
			})
			return
		}

		for _, sub := range subs {
			key := strconv.Itoa(int(sub.ID))
			if detail, ok := subData[key]; ok {
				detail.Packagetype = sub.Packagetype
				subData[key] = detail
			}
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
