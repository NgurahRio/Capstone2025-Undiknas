package utils


import "encoding/base64"

func ToBase64(data []byte, fileType string) string {
    if len(data) == 0 {
        return ""
    }

    encoded := base64.StdEncoding.EncodeToString(data)

    return "data:image/" + fileType + ";base64," + encoded
}
