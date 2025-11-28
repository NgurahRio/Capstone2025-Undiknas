package destination

import (
	"backend/config"
	"backend/models"
	"encoding/base64"
	"io"
	"net/http"
	"path/filepath"
	"strconv"
	"strings"
	"fmt"

	"github.com/gin-gonic/gin"
)

func UpdateDestination(c *gin.Context) {
	id := c.Param("id")

	var destination models.Destination

	if err := config.DB.First(&destination, "id_destination = ?", id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"message": "Destinasi tidak ditemukan"})
		return
	}

	changed := make(map[string]interface{})

	if v := c.PostForm("subcategoryId"); v != "" {

		subcategoryIDs := strings.Split(v, ",")

		for _, idStr := range subcategoryIDs {
			idInt, _ := strconv.Atoi(strings.TrimSpace(idStr))

			var s models.Subcategory
			if err := config.DB.First(&s, "id_subcategory = ?", idInt).Error; err != nil {
				c.JSON(http.StatusBadRequest, gin.H{
					"message": fmt.Sprintf("Subcategory ID %d tidak ditemukan", idInt),
				})
				return
			}
		}

		destination.SubcategoryID = v
		changed["subcategoryId"] = v
	}

	if v := c.PostForm("namedestination"); v != "" {
		destination.Name = v
		changed["namedestination"] = v
	}

	if v := c.PostForm("location"); v != "" {
		destination.Location = v
		changed["location"] = v
	}

	if v := c.PostForm("description"); v != "" {
		destination.Description = v
		changed["description"] = v
	}

	if v := c.PostForm("do"); v != "" {
		destination.Do = v
		changed["do"] = v
	}

	if v := c.PostForm("dont"); v != "" {
		destination.Dont = v
		changed["dont"] = v
	}

	if v := c.PostForm("safety"); v != "" {
		destination.Safety = v
		changed["safety"] = v
	}

	if v := c.PostForm("maps"); v != "" {
		destination.Maps = v
		changed["maps"] = v
	}

	if v := c.PostForm("sosId"); v != "" {
		if n, err := strconv.Atoi(v); err == nil {
			destination.SosID = uint(n)
			changed["sosId"] = n
		}
	}

	if v := c.PostForm("longitude"); v != "" {
		if f, err := strconv.ParseFloat(v, 64); err == nil {
			destination.Longitude = f
			changed["longitude"] = f
		}
	}

	if v := c.PostForm("latitude"); v != "" {
		if f, err := strconv.ParseFloat(v, 64); err == nil {
			destination.Latitude = f
			changed["latitude"] = f
		}
	}

	if v := c.PostForm("facilityId"); v != "" {

		facilityIDs := strings.Split(v, ",")

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

		destination.FacilityID = v
		changed["facilityId"] = v
	}

	file, err := c.FormFile("image")
	if err == nil {
		opened, _ := file.Open()
		defer opened.Close()

		rawBytes, _ := io.ReadAll(opened)
		base64Str := base64.StdEncoding.EncodeToString(rawBytes)

		destination.ImageURL = []byte(base64Str)
		destination.FileType = strings.TrimPrefix(strings.ToLower(filepath.Ext(file.Filename)), ".")

		changed["image"] = "updated"
	}

	if err := config.DB.Save(&destination).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": "Gagal mengupdate destinasi",
		})
		return
	}

	if len(changed) == 0 {
		c.JSON(http.StatusOK, gin.H{"message": "Tidak ada perubahan"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Berhasil diubah",
		"changed": changed,
	})
}
