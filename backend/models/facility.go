package models

type Facility struct {
	IDFacility   uint   `gorm:"column:id_facility;primaryKey;autoIncrement" json:"id_facility"`
	NameFacility string `gorm:"column:namefacility" json:"namefacility"`
	Icon         []byte `gorm:"column:icon" json:"icon"`
	FileType     string `gorm:"column:file_type" json:"file_type"`
}

func (Facility) TableName() string {
	return "facility"
}
