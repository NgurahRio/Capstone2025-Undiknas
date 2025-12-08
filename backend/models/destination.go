package models

type Destination struct {
	ID            uint    `gorm:"primaryKey;column:id_destination" json:"id_destination"`
	SubcategoryID string  `gorm:"column:subcategoryId;type:longtext" json:"subcategoryId"`
	Name          string  `gorm:"column:namedestination" json:"namedestination"`
	Location      string  `gorm:"column:location" json:"location"`
	Description   string  `gorm:"column:description" json:"description"`
	Imagedata     string  `gorm:"column:imagedata" json:"imagedata"`
	Do            string  `gorm:"column:do" json:"do"`
	Dont          string  `gorm:"column:dont" json:"dont"`
	Safety        string  `gorm:"column:safety" json:"safety"`
	Maps          string  `gorm:"column:maps" json:"maps"`
	SosID         uint    `gorm:"column:sosId" json:"sosId"`
	CreatedAt     string  `gorm:"column:created_at" json:"created_at"`
	UpdatedAt     string  `gorm:"column:updated_at" json:"updated_at"`
	FacilityID    string  `gorm:"column:facilityId;type:longtext" json:"facilityId"`
	Longitude     float64 `gorm:"column:longitude" json:"longitude"`
	Latitude      float64 `gorm:"column:latitude" json:"latitude"`
}

func (Destination) TableName() string {
	return "destination"
}
