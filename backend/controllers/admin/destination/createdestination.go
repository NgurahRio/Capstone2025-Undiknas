package destination

import (
	"backend/config"
	"backend/models"
	"backend/utils"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"strconv"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
)

type destinationImage struct {
	Image string `json:"image"`
}

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

	form, formErr := c.MultipartForm()
	if formErr != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": "Form-data tidak valid"})
		return
	}

	var images []destinationImage

	for key, files := range form.File {
		if strings.HasPrefix(key, "image[") && strings.HasSuffix(key, "]") {

			file := files[0]

			openFile, err := file.Open()
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{
					"message": "Gagal membuka file pada key: " + key,
				})
				return
			}

			rawBytes, readErr := io.ReadAll(openFile)
			openFile.Close()
			if readErr != nil {
				c.JSON(http.StatusBadRequest, gin.H{
					"message": "Gagal membaca file pada key: " + key,
				})
				return
			}

			base64Str := base64.StdEncoding.EncodeToString(rawBytes)

			images = append(images, destinationImage{
				Image: base64Str,
			})
		}
	}

	if len(images) == 0 {
		c.JSON(http.StatusBadRequest, gin.H{"message": "Minimal 1 image wajib diupload (gunakan image[0], image[1], ...)"})
		return
	}


	jsonBytes, _ := json.Marshal(images)
	nowStr := time.Now().Format("2006-01-02 15:04:05")

	destination := models.Destination{
		SubcategoryID: rawSubcategory,
		Name:          name,
		Location:      location,
		Description:   description,
		Imagedata:     string(jsonBytes),
		Do:            do,
		Dont:          dont,
		Safety:        safety,
		Maps:          maps,
		SosID:         uint(sosID),
		FacilityID:    rawFacility,
		Longitude:     longitude,
		Latitude:      latitude,
		CreatedAt:     nowStr,
		UpdatedAt:     nowStr,
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

	var subIDsInt []int
	for _, id := range subcategoryIDs {
		n, _ := strconv.Atoi(strings.TrimSpace(id))
		subIDsInt = append(subIDsInt, n)
	}

	config.DB.Where("id_subcategories IN ?", subIDsInt).Find(&subcategories)

	for _, s := range subcategories {
		subResp = append(subResp, gin.H{
			"id_subcategories":  s.ID,
			"namesubcategories": s.Name,
			"categoriesId":      s.CategoryID,
		})
	}

	var facilities []models.Facility
	var facResp []gin.H

	var facIDsInt []int
	for _, id := range facilityIDs {
		n, _ := strconv.Atoi(strings.TrimSpace(id))
		facIDsInt = append(facIDsInt, n)
	}

	config.DB.Where("id_facility IN ?", facIDsInt).Find(&facilities)

	for _, f := range facilities {
		facResp = append(facResp, gin.H{
			"id_facility":  f.IDFacility,
			"namefacility": f.NameFacility,
			"icon":         utils.ToBase64(f.Icon),
		})
	}

	c.JSON(http.StatusCreated, gin.H{
		"message": "Destination berhasil ditambahkan",
		"data": gin.H{
			"destination": gin.H{
				"id_destination":  destination.ID,
				"namedestination": destination.Name,
				"location":        destination.Location,
				"description":     destination.Description,
				"images":          images,
				"do":              destination.Do,
				"dont":            destination.Dont,
				"safety":          destination.Safety,
				"maps":            destination.Maps,
				"sosId":           destination.SosID,
				"facilityId":      destination.FacilityID,
				"subcategoryId":   destination.SubcategoryID,
				"longitude":       destination.Longitude,
				"latitude":        destination.Latitude,
				"created_at":      destination.CreatedAt,
				"updated_at":      destination.UpdatedAt,
			},
			"subcategory": subResp,
			"facilities":  facResp,
		},
	})
}
