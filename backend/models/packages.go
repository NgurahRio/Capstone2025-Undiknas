package models

type Packages struct {
	ID             uint   `gorm:"primaryKey;column:id_packages" json:"id_packages"`
	DestinationID  uint   `gorm:"column:destinationId" json:"destinationId"`
	SubPackageData string `gorm:"column:subpackage_data" json:"subpackage_data"`
}

func (Packages) TableName() string {
	return "packages"
}