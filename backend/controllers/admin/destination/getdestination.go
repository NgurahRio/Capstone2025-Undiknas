package destination

import (
	"backend/config"
	"backend/models"
	"backend/utils"
	"encoding/json"
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
)

func normalizeImages(data string) []string {
	if data == "" {
		return []string{}
	}

	var images []string

	if err := json.Unmarshal([]byte(data), &images); err == nil {
		return images
	}

	raw := strings.Split(data, ",")
	for _, item := range raw {
		item = strings.TrimSpace(item)
		if item != "" {
			images = append(images, item)
		}
	}

	return images
}

func GetAllDestinations(c *gin.Context) {

	var destinations []models.Destination
<<<<<<< HEAD
	if err := config.DB.
		Preload("Subcategories").
		Preload("Facilities").
		Find(&destinations).Error; err != nil {
=======
	if err := config.DB.Preload("SOS").Find(&destinations).Error; err != nil {
>>>>>>> b4e98ee73673f3dc88a6e41815b9f82c5115984e
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": "Gagal mengambil data destinasi",
		})
		return
	}

	var response []gin.H

	for _, d := range destinations {
		images := normalizeImages(d.Imagedata)

		var facilityResp []gin.H
		for _, f := range d.Facilities {
			facilityResp = append(facilityResp, gin.H{
				"id_facility":  f.IDFacility,
				"namefacility": f.NameFacility,
				"icon":         utils.ToBase64(f.Icon),
			})
		}

		var subResp []gin.H
		for _, s := range d.Subcategories {
			subResp = append(subResp, gin.H{
				"id_subcategory":   s.ID,
				"name_subcategory": s.Name,
				"category_id":      s.CategoryID,
			})
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

func GetDestinationByID(c *gin.Context) {
	id := c.Param("id")

	var d models.Destination
<<<<<<< HEAD
	if err := config.DB.
		Preload("Subcategories").
		Preload("Facilities").
		First(&d, "id_destination = ?", id).Error; err != nil {
=======
	if err := config.DB.Preload("SOS").First(&d, "id_destination = ?", id).Error; err != nil {
>>>>>>> b4e98ee73673f3dc88a6e41815b9f82c5115984e
		c.JSON(http.StatusNotFound, gin.H{
			"message": "Destinasi tidak ditemukan",
		})
		return
	}

	images := normalizeImages(d.Imagedata)

	var facilityResp []gin.H
	for _, f := range d.Facilities {
		facilityResp = append(facilityResp, gin.H{
			"id_facility":  f.IDFacility,
			"namefacility": f.NameFacility,
			"icon":         utils.ToBase64(f.Icon),
		})
	}

	var subResp []gin.H
	for _, s := range d.Subcategories {
		subResp = append(subResp, gin.H{
			"id_subcategory":   s.ID,
			"name_subcategory": s.Name,
			"category_id":      s.CategoryID,
		})
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
