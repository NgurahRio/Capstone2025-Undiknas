package event

import (
	"backend/config"
	"backend/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

// ✅ CREATE event
func CreateEvent(c *gin.Context) {
	var input struct {
		DestinationID int     `json:"destinationId" binding:"required"`
		NameEvent     string  `json:"nameevent" binding:"required"`
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

	event := models.Event{
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
	}

	if err := config.DB.Create(&event).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal menambahkan event"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Event berhasil ditambahkan",
		"data":    event,
	})
}
