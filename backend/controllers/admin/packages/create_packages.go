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

	// ============================
	// VALIDASI destinationId
	// ============================
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

	// Cek apakah destination ada
	var destCheck models.Destination
	if err := config.DB.First(&destCheck, "id_destination = ?", destID).Error; err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": "destinationId tidak ditemukan di database"})
		return
	}

	// ============================
	// Ambil array dari Form-Data (TANPA [])
	// ============================
	subIDs := c.PostFormArray("subPackageId")
	prices := c.PostFormArray("price")

	form, formErr := c.MultipartForm()
	if formErr != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": "Form tidak valid"})
		return
	}

	files := form.File["image"]

	// ============================
	// DEBUG (PENTING!!)
	// ============================
	fmt.Println("DEBUG SUB IDS  :", subIDs)
	fmt.Println("DEBUG PRICES  :", prices)
	fmt.Println("DEBUG IMAGES  :", len(files))

	// ============================
	// Validasi jumlah array
	// ============================
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

	// ============================
	// Ambil data existing dari DB
	// ============================
	var pkg models.Packages
	findErr := config.DB.First(&pkg, "destinationId = ?", destID).Error

	existingJSON := map[string]interface{}{}
	if findErr == nil && pkg.SubPackageData != "" {
		json.Unmarshal([]byte(pkg.SubPackageData), &existingJSON)
	}

	// ============================
	// LOOP SUBPACKAGES
	// ============================
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

		// Cek subpackage ada
		var subCheck models.SubPackage
		if err := config.DB.First(&subCheck, "id_subpackage = ?", subIDInt).Error; err != nil {
			c.JSON(http.StatusBadRequest, gin.H{
				"message": "subPackageId tidak ditemukan di tabel subpackage",
				"value":   subIDInt,
			})
			return
		}

		// Harga
		priceVal, priceErr := strconv.ParseFloat(prices[i], 64)
		if priceErr != nil {
			c.JSON(http.StatusBadRequest, gin.H{
				"message": "Harga tidak valid pada index " + strconv.Itoa(i),
				"value":   prices[i],
			})
			return
		}

		// File image
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

		// Simpan ke JSON MAP
		existingJSON[subID] = map[string]interface{}{
			"price": priceVal,
			"image": base64Img,
		}
	}

	// ============================
	// SAVE KE DATABASE
	// ============================
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