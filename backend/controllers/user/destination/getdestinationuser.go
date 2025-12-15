package destination

import (
	"backend/config"
	"backend/models"
	"backend/utils"
	"encoding/json"
	"net/http"
	"strconv"
	"strings"

	"github.com/gin-gonic/gin"
)

type destinationImages struct {
	Image string `json:"image"`
}

func GetAllDestinationsUser(c *gin.Context) {

	var destinations []models.Destination
	if err := config.DB.Preload("SOS").Find(&destinations).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": "Gagal mengambil data destinasi",
		})
		return
	}

	var response []gin.H

	for _, d := range destinations {

		var images []destinationImages
		_ = json.Unmarshal([]byte(d.Imagedata), &images)

		var subcategories []models.Subcategory
		var subResp []gin.H

		if d.SubcategoryID != "" {
			rawSubs := strings.Split(d.SubcategoryID, ",")
			intIDs := []int{}
			for _, idStr := range rawSubs {
				if n, err := strconv.Atoi(strings.TrimSpace(idStr)); err == nil {
					intIDs = append(intIDs, n)
				}
			}

			config.DB.Where("id_subcategories IN ?", intIDs).Find(&subcategories)

			for _, s := range subcategories {
				subResp = append(subResp, gin.H{
					"id_subcategory":   s.ID,
					"name_subcategory": s.Name,
					"category_id":      s.CategoryID,
				})
			}
		}

		var facilities []models.Facility
		var facilityResp []gin.H

		if d.FacilityID != "" {
			rawIDs := strings.Split(d.FacilityID, ",")
			intIDs := []int{}
			for _, idStr := range rawIDs {
				if n, err := strconv.Atoi(strings.TrimSpace(idStr)); err == nil {
					intIDs = append(intIDs, n)
				}
			}

			config.DB.Where("id_facility IN ?", intIDs).Find(&facilities)

			for _, f := range facilities {
				facilityResp = append(facilityResp, gin.H{
					"id_facility":  f.IDFacility,
					"namefacility": f.NameFacility,
					"icon":         utils.ToBase64(f.Icon),
				})
			}
		}

		response = append(response, gin.H{
			"id_destination":  d.ID,
			"subcategoryId":   d.SubcategoryID,
			"subcategory":     subResp,
			"namedestination": d.Name,
			"location":        d.Location,
			"description":     d.Description,
			"images":          images,
			"do":              d.Do,
			"dont":            d.Dont,
			"safety":          d.Safety,
			"maps":            d.Maps,
			"longitude":       d.Longitude,
			"latitude":        d.Latitude,
			"facilityId":      d.FacilityID,
			"facilities":      facilityResp,
			"sosId":           d.SosID,
			"sos": gin.H{
				"id_sos":     d.SOS.ID,
				"name_sos":   d.SOS.Name,
				"alamat_sos": d.SOS.Alamat,
				"telepon":    d.SOS.Telepon,
			},
		})
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Berhasil mengambil semua destinasi",
		"data":    response,
	})
}

func GetDestinationByIDUser(c *gin.Context) {
	id := c.Param("id")

	var d models.Destination
	if err := config.DB.Preload("SOS").First(&d, "id_destination = ?", id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{
			"message": "Destinasi tidak ditemukan",
		})
		return
	}

	var images []destinationImages
	_ = json.Unmarshal([]byte(d.Imagedata), &images)

	var subcategories []models.Subcategory
	var subResp []gin.H

	if d.SubcategoryID != "" {
		rawSubs := strings.Split(d.SubcategoryID, ",")
		intIDs := []int{}
		for _, idStr := range rawSubs {
			if n, err := strconv.Atoi(strings.TrimSpace(idStr)); err == nil {
				intIDs = append(intIDs, n)
			}
		}

		config.DB.Where("id_subcategories IN ?", intIDs).Find(&subcategories)

		for _, s := range subcategories {
			subResp = append(subResp, gin.H{
				"id_subcategory":   s.ID,
				"name_subcategory": s.Name,
				"category_id":      s.CategoryID,
			})
		}
	}

	var facilities []models.Facility
	var facilityResp []gin.H

	if d.FacilityID != "" {
		rawIDs := strings.Split(d.FacilityID, ",")
		intIDs := []int{}
		for _, idStr := range rawIDs {
			if n, err := strconv.Atoi(strings.TrimSpace(idStr)); err == nil {
				intIDs = append(intIDs, n)
			}
		}

		config.DB.Where("id_facility IN ?", intIDs).Find(&facilities)

		for _, f := range facilities {
			facilityResp = append(facilityResp, gin.H{
				"id_facility":  f.IDFacility,
				"namefacility": f.NameFacility,
				"icon":         utils.ToBase64(f.Icon),
			})
		}
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Berhasil mengambil data destinasi",
		"data": gin.H{
			"id_destination":  d.ID,
			"subcategoryId":   d.SubcategoryID,
			"subcategory":     subResp,
			"namedestination": d.Name,
			"location":        d.Location,
			"description":     d.Description,
			"images":          images,
			"do":              d.Do,
			"dont":            d.Dont,
			"safety":          d.Safety,
			"maps":            d.Maps,
			"longitude":       d.Longitude,
			"latitude":        d.Latitude,
			"facilityId":      d.FacilityID,
			"facilities":      facilityResp,
			"sosId":           d.SosID,
			"sos": gin.H{
				"id_sos":     d.SOS.ID,
				"name_sos":   d.SOS.Name,
				"alamat_sos": d.SOS.Alamat,
				"telepon":    d.SOS.Telepon,
			},
		},
	})
}
