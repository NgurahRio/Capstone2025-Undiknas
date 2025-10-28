package models

type Destination struct {
	ID            uint    `gorm:"primaryKey;column:id_destination" json:"id_destination"`
	SubCategoryID uint    `gorm:"column:subcategoryId;not null" json:"subcategoryId"`
	Name          string  `gorm:"column:namedestination;not null" json:"namedestination"`
	Location      string  `gorm:"column:location" json:"location"`
	Description   string  `gorm:"column:description" json:"description"`
	TicketPrice   float64 `gorm:"column:ticket_price" json:"ticket_price"`
	ImageURL      []byte  `gorm:"column:image_url" json:"image_url"`
	FileType      string  `gorm:"column:file_type" json:"file_type"`
	CreatedAt     string  `gorm:"column:created_at" json:"created_at"`
	UpdatedAt     string  `gorm:"column:updated_at" json:"updated_at"`
}

func (Destination) TableName() string {
	return "destination"
}