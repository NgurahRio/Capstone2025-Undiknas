package models

type Event struct {
	ID            uint   `gorm:"primaryKey;column:id_events" json:"id_events"`
	DestinationID uint   `gorm:"column:destinationId;not null" json:"destinationId"`
	Name          string `gorm:"column:nameevent;not null" json:"nameevent"`
	StartDate     string `gorm:"column:start_date" json:"start_date"`
	EndDate       string `gorm:"column:end_date" json:"end_date"`
	Description   string `gorm:"column:description" json:"description"`
}

func (Event) TableName() string {
	return "event"
}