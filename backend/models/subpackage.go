package models

type SubPackage struct {
	ID          int    `json:"id"`
	Packagetype string `json:"package_type"`
	Name        string `json:"name"`
	Image       []byte `json:"image"`
}

func (SubPackage) TableName() string {
	return "sub_package"
}
