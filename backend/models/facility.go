package models

type Facility struct {
	ID            uint   `gorm:"column:id_facility;primaryKey" json:"id_facility"`
	IconURL       string `gorm:"column:icon_url" json:"icon_url"`
	Text          string `gorm:"column:text" json:"text"`
	DestinationId uint   `gorm:"column:destinationId" json:"destinationId"`
}

func (Facility) TableName() string {
	return "facility"
}
