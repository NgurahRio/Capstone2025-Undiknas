package event

import (
	"backend/config"
	"backend/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

// ✅ UPDATE event
func UpdateEvent(c *gin.Context) {
	id := c.Param("id")
	var event models.Event

	if err := config.DB.First(&event, id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Event tidak ditemukan"})
		return
	}

	var input struct {
		DestinationID int     `json:"destinationId"`
		NameEvent     string  `json:"nameevent"`
		StartDate     string  `json:"start_date"`
		EndDate       string  `json:"end_date"`
		Description   string  `json:"description"`
		StartTime     string  `json:"start_time"`
		EndTime       string  `json:"end_time"`
		Price         float64 `json:"price"`
		Maps          string  `json:"maps"`
		Do            string  `json:"do"`
		Dont          string  `json:"dont"`
		Safety        string  `json:"safety"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := config.DB.Model(&event).Updates(models.Event{
		DestinationID: uint(input.DestinationID),
		Name:          input.NameEvent,
		StartDate:     input.StartDate,
		EndDate:       input.EndDate,
		Description:   input.Description,
		StartTime:     input.StartTime,
		EndTime:       input.EndTime,
		Price:         input.Price,
		Maps:          input.Maps,
		Do:            input.Do,
		Dont:          input.Dont,
		Safety:        input.Safety,
	}).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal memperbarui event"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Event berhasil diperbarui",
		"data":    event,
	})
}
