package destination

import (
	"backend/config"
	"backend/models"
	"backend/utils"
	"encoding/base64"
	"fmt"
	"io"
	"net/http"
	"path/filepath"
	"strconv"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
)

func CreateDestination(c *gin.Context) {
	rawSubcategory := c.PostForm("subcategoryId")
	if rawSubcategory == "" {
		c.JSON(http.StatusBadRequest, gin.H{"message": "subcategoryId wajib diisi (contoh: 1,4,7)"})
		return
	}

	name := c.PostForm("namedestination")
	location := c.PostForm("location")
	description := c.PostForm("description")
	do := c.PostForm("do")
	dont := c.PostForm("dont")
	safety := c.PostForm("safety")
	maps := c.PostForm("maps")
	sosID, _ := strconv.Atoi(c.PostForm("sosId"))
	longitude, _ := strconv.ParseFloat(c.PostForm("longitude"), 64)
	latitude, _ := strconv.ParseFloat(c.PostForm("latitude"), 64)

	rawFacility := c.PostForm("facilityId")
	if rawFacility == "" {
		c.JSON(http.StatusBadRequest, gin.H{"message": "facilityId wajib diisi (contoh: 1,3,5)"})
		return
	}

	facilityIDs := strings.Split(rawFacility, ",")
	for _, idStr := range facilityIDs {
		idInt, _ := strconv.Atoi(strings.TrimSpace(idStr))

		var f models.Facility
		if err := config.DB.First(&f, "id_facility = ?", idInt).Error; err != nil {
			c.JSON(http.StatusBadRequest, gin.H{
				"message": fmt.Sprintf("Facility ID %d tidak ditemukan", idInt),
			})
			return
		}
	}

	subcategoryIDs := strings.Split(rawSubcategory, ",")
	for _, idStr := range subcategoryIDs {
		idInt, _ := strconv.Atoi(strings.TrimSpace(idStr))

		var s models.Subcategory
		if err := config.DB.First(&s, "id_subcategories = ?", idInt).Error; err != nil {
			c.JSON(http.StatusBadRequest, gin.H{
				"message": fmt.Sprintf("Subcategory ID %d tidak ditemukan", idInt),
			})
			return
		}
	}

	var imageBytes []byte
	var fileType string

	file, err := c.FormFile("image")
	if err == nil {
		opened, err := file.Open()
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"message": "Tidak bisa membuka file gambar"})
			return
		}
		defer opened.Close()

		rawBytes, _ := io.ReadAll(opened)
		base64Str := base64.StdEncoding.EncodeToString(rawBytes)
		imageBytes = []byte(base64Str)

		fileType = strings.TrimPrefix(strings.ToLower(filepath.Ext(file.Filename)), ".")
	}

	destination := models.Destination{
		SubcategoryID: rawSubcategory,
		Name:          name,
		Location:      location,
		Description:   description,
		ImageURL:      imageBytes,
		FileType:      fileType,
		Do:            do,
		Dont:          dont,
		Safety:        safety,
		Maps:          maps,
		SosID:         uint(sosID),
		FacilityID:    rawFacility,
		Longitude:     longitude,
		Latitude:      latitude,
		CreatedAt:     time.Now().Format("2006-01-02 15:04:05"),
		UpdatedAt:     time.Now().Format("2006-01-02 15:04:05"),
	}

	if err := config.DB.Create(&destination).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": "Gagal menambahkan destinasi",
			"error":   err.Error(),
		})
		return
	}

	var subcategories []models.Subcategory
	var subResp []gin.H

	rawSubs := strings.Split(destination.SubcategoryID, ",")
	subIDs := []int{}

	for _, idStr := range rawSubs {
		if n, err := strconv.Atoi(strings.TrimSpace(idStr)); err == nil {
			subIDs = append(subIDs, n)
		}
	}

	config.DB.Where("id_subcategories IN ?", subIDs).Find(&subcategories)

	for _, s := range subcategories {
		subResp = append(subResp, gin.H{
			"id_subcategories":  s.ID,
			"namesubcategories": s.Name,
			"categoriesId":      s.CategoryID,
		})
	}

	var facilities []models.Facility
	var facResp []gin.H

	rawFac := strings.Split(destination.FacilityID, ",")
	facIDs := []int{}

	for _, idStr := range rawFac {
		if n, err := strconv.Atoi(strings.TrimSpace(idStr)); err == nil {
			facIDs = append(facIDs, n)
		}
	}

	config.DB.Where("id_facility IN ?", facIDs).Find(&facilities)

	for _, f := range facilities {
		facResp = append(facResp, gin.H{
			"id_facility":  f.IDFacility,
			"namefacility": f.NameFacility,
			"icon":         utils.ToBase64(f.Icon, f.FileType),
			"file_type":    f.FileType,
		})
	}

	c.JSON(http.StatusCreated, gin.H{
		"message": "Destination berhasil ditambahkan",
		"data": gin.H{
			"destination": destination,
			"subcategory": subResp,
			"facilities":  facResp,
		},
	})
}
