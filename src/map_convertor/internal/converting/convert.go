package converting

import (
	"encoding/binary"
	"encoding/json"
	"os"
)

type vec3 [3]float32

type Block struct {
	scaleVec      vec3  `json:"scale"`
	translateVec  vec3  `json:"translate"`
	textureOffset int32 `json:"texture"`
	materiaOffset int32 `json:"material"`
	colisionDet   int32 `json:"colision"`
	blockType     int32 `json:"block"`
}

type Map struct {
	Map []Block `json:"map"`
}

func (mapSt *Map) ReadJson(fileName string) error {
	// Open file with map
	jsonFile, err := os.Open(fileName)
	if err != nil {
		return err
	}
	defer jsonFile.Close()

	// Stats of the file
	jsFileSt, err := jsonFile.Stat()
	if err != nil {
		return err
	}

	// Read file to []byte
	jsBytes := make([]byte, jsFileSt.Size())
	_, err = jsonFile.Read(jsBytes)
	if err != nil {
		return err
	}

	if err := json.Unmarshal(jsBytes, &mapSt.Map); err != nil {
		return err
	}

	return nil
}

func (mapSt *Map) WriteBinary(filename string) error {
	// Create new file to write map json
	binFile, err := os.Create(filename)
	if err != nil {
		return err
	}
	defer binFile.Close()

	err = binary.Write(binFile, binary.LittleEndian, mapSt.Map)
	return nil
}
