package packagess

import (
	"backend/config"
	"backend/models"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

func CreatePackages(c *gin.Context) {

	destIDStr := c.PostForm("destinationId")
	if destIDStr == "" {
		c.JSON(http.StatusBadRequest, gin.H{"message": "destinationId wajib diisi"})
		return
	}

	destID, convErr := strconv.Atoi(destIDStr)
	if convErr != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": "destinationId harus berupa angka"})
		return
	}
	var destCheck models.Destination
	if err := config.DB.First(&destCheck, "id_destination = ?", destID).Error; err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": "destinationId tidak ditemukan di database"})
		return
	}

	subIDs := c.PostFormArray("subPackageId")
	prices := c.PostFormArray("price")
	includeNames := c.PostFormArray("includeName")

	form, formErr := c.MultipartForm()
	if formErr != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": "Form tidak valid"})
		return
	}

	files := form.File["image"]

	fmt.Println("DEBUG SUB IDS  :", subIDs)
	fmt.Println("DEBUG PRICES  :", prices)
	fmt.Println("DEBUG IMAGES  :", len(files))

	if len(subIDs) == 0 {
		c.JSON(http.StatusBadRequest, gin.H{"message": "subPackageId wajib diisi"})
		return
	}

	if len(prices) != len(subIDs) {
		c.JSON(http.StatusBadRequest, gin.H{
			"message": "Jumlah price harus sama dengan subPackageId",
			"detail": gin.H{
				"subPackageId": len(subIDs),
				"price":        len(prices),
			},
		})
		return
	}

	if len(files) != len(subIDs) {
		c.JSON(http.StatusBadRequest, gin.H{
			"message": "Jumlah image harus sama dengan subPackageId",
			"detail": gin.H{
				"subPackageId": len(subIDs),
				"image":        len(files),
			},
		})
		return
	}

	var pkg models.Packages
	findErr := config.DB.First(&pkg, "destinationId = ?", destID).Error

	existingJSON := map[string]subPackageDetail{}
	if findErr == nil && pkg.SubPackageData != "" {
		existingJSON = normalizeSubPackageData(pkg.SubPackageData)
	}

	for i := range subIDs {

		subID := subIDs[i]

		if subID == "" {
			c.JSON(http.StatusBadRequest, gin.H{
				"message": "subPackageId di index " + strconv.Itoa(i) + " kosong",
			})
			return
		}

		subIDInt, errConv := strconv.Atoi(subID)
		if errConv != nil {
			c.JSON(http.StatusBadRequest, gin.H{
				"message": "subPackageId harus angka",
				"value":   subID,
			})
			return
		}

		var subCheck models.SubPackage
		if err := config.DB.First(&subCheck, "id_subpackage = ?", subIDInt).Error; err != nil {
			c.JSON(http.StatusBadRequest, gin.H{
				"message": "subPackageId tidak ditemukan di tabel subpackage",
				"value":   subIDInt,
			})
			return
		}

		priceVal, priceErr := strconv.ParseFloat(prices[i], 64)
		if priceErr != nil {
			c.JSON(http.StatusBadRequest, gin.H{
				"message": "Harga tidak valid pada index " + strconv.Itoa(i),
				"value":   prices[i],
			})
			return
		}

		file := files[i]
		opened, openErr := file.Open()
		if openErr != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"message": "Gagal membuka file image"})
			return
		}

		imgBytes, readErr := io.ReadAll(opened)
		opened.Close()
		if readErr != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"message": "Gagal membaca file image"})
			return
		}

		base64Img := base64.StdEncoding.EncodeToString(imgBytes)

		detail, exist := existingJSON[subID]
		if !exist {
			detail = subPackageDetail{
				Price:   priceVal,
				Include: []subPackageInclude{},
			}
		} else {
			detail.Price = priceVal
		}

		nameVal := subCheck.Packagetype
		if len(includeNames) > i && includeNames[i] != "" {
			nameVal = includeNames[i]
		}

		detail.Include = append(detail.Include, subPackageInclude{
			Image: base64Img,
			Name:  nameVal,
		})

		existingJSON[subID] = detail
	}

	jsonBytes, _ := json.MarshalIndent(existingJSON, "", "  ")

	if findErr != nil {
		pkg = models.Packages{
			DestinationID:  uint(destID),
			SubPackageData: string(jsonBytes),
		}

		if err := config.DB.Create(&pkg).Error; err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{
				"message": "Gagal menambahkan package baru",
				"error":   err.Error(),
			})
			return
		}

	} else {
		pkg.SubPackageData = string(jsonBytes)

		if err := config.DB.Save(&pkg).Error; err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{
				"message": "Gagal mengupdate package",
				"error":   err.Error(),
			})
			return
		}
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Package berhasil disimpan",
		"data":    pkg,
	})
}
