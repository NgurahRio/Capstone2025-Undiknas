package facility

import (
	"backend/config"
	"backend/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

func GetFacilityByDestination(c *gin.Context) {
	destinationId := c.Param("destinationId")

	var facilities []models.Facility

	if err := config.DB.
		Where("destinationId = ?", destinationId).
		Find(&facilities).Error; err != nil {

		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, facilities)
}
