package models

type Destination struct {
	ID             uint   `gorm:"primaryKey;column:id_destination" json:"id_destination"`
	SubcategoryID  uint   `gorm:"column:subcategoryId;not null" json:"subcategoryId"`
	Name           string `gorm:"column:namedestination" json:"namedestination"`
	Location       string `gorm:"column:location" json:"location"`
	Description    string `gorm:"column:description" json:"description"`
	ImageURL       []byte `gorm:"column:image_url" json:"image_url"`
	FileType       string `gorm:"column:file_type" json:"file_type"`
	Fasilitas      string `gorm:"column:fasilitas" json:"fasilitas"`
	Do             string `gorm:"column:do" json:"do"`
	Dont           string `gorm:"column:dont" json:"dont"`
	Safety         string `gorm:"column:safety" json:"safety"`
	Maps           string `gorm:"column:maps" json:"maps"`
	SosID          uint   `gorm:"column:sosId" json:"sosId"`
	CreatedAt      string `gorm:"column:created_at" json:"created_at"`
	UpdatedAt      string `gorm:"column:updated_at" json:"updated_at"`
}

func (Destination) TableName() string {
	return "destination"
}