package destination

import (
	"backend/config"
	"backend/models"
	"backend/utils"
	"net/http"
	"strconv"
	"strings"

	"github.com/gin-gonic/gin"
)

func GetAllDestinationsUser(c *gin.Context) {
	var destinations []models.Destination

	if err := config.DB.Find(&destinations).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": "Gagal mengambil data destinasi",
		})
		return
	}

	var response []gin.H

	for _, d := range destinations {
		imageBase64 := utils.ToBase64(d.ImageURL, d.FileType)

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
					"icon":         utils.ToBase64(f.Icon, f.FileType),
					"file_type":    f.FileType,
				})
			}
		}

		response = append(response, gin.H{
			"destination": gin.H{
				"id_destination":  d.ID,
				"subcategoryId":   d.SubcategoryID, 
				"subcategory":     subResp,         
				"namedestination": d.Name,
				"location":        d.Location,
				"description":     d.Description,
				"image_url":       imageBase64,
				"file_type":       d.FileType,
				"do":              d.Do,
				"dont":            d.Dont,
				"safety":          d.Safety,
				"maps":            d.Maps,
				"longitude":       d.Longitude,
				"latitude":        d.Latitude,
				"facilityId":      d.FacilityID,
			},
			"facilities": facilityResp,
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

	if err := config.DB.First(&d, "id_destination = ?", id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"message": "Destinasi tidak ditemukan"})
		return
	}

	imageBase64 := utils.ToBase64(d.ImageURL, d.FileType)

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
				"icon":         utils.ToBase64(f.Icon, f.FileType),
				"file_type":    f.FileType,
			})
		}
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Berhasil mengambil data destinasi",
		"data": gin.H{
			"destination": gin.H{
				"id_destination":  d.ID,
				"subcategoryId":   d.SubcategoryID,
				"subcategory":     subResp,
				"namedestination": d.Name,
				"location":        d.Location,
				"description":     d.Description,
				"image_url":       imageBase64,
				"file_type":       d.FileType,
				"do":              d.Do,
				"dont":            d.Dont,
				"safety":          d.Safety,
				"maps":            d.Maps,
				"longitude":       d.Longitude,
				"latitude":        d.Latitude,
				"facilityId":      d.FacilityID,
			},
			"facilities": facilityResp,
		},
	})
}
