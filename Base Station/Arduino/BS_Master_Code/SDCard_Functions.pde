// Include SD Library
#include <SdFat.h>

// SD Variables
Sd2Card card;
SdVolume volume;
SdFile root;
SdFile file;

// File name to write to and read from
  char fileName[] = "READINGS.CSV";
  
void writeToSD(String data)
{
  // Initate the card at FULL speed
  if (!card.init(SPI_FULL_SPEED))
  {
    return;
  } 
  
  // Initiate the FAT volume
  if (!volume.init(&card))
  {
    return;
  }
  
  // Open the root directory
  if (!root.openRoot(&volume))
  {
    return;
  }
  
  // Now do the writing - clear error buffer first
  file.writeError = false;
  
  // Open the File
  // O_CREAT - create the file if it does not exist
  // O_APPEND - seek to the end of the file prior to each write
  // O_WRITE - open for write
  
  if (!file.open(&root, fileName, O_CREAT | O_APPEND | O_WRITE))
  {
    // Cant create or open file
    return;
  }
  
  // Write to the file
  file.println(data);
  // Close the file
  file.close();    
}


char* readFromSD()
{
  char buffer[70];
  // Initate the card at FULL speed
  card.init(SPI_FULL_SPEED);
  // Initiate the FAT volume
  volume.init(&card);  
  // Open the root directory
  root.openRoot(&volume);
  // Open the file to read
  file.open(&root, fileName, O_READ);
  // Start reading in the file
  int n;
  // Read in the file to the buffer
  while ((n = file.read(buffer, sizeof(buffer))) > 0)
  {
    
  }
  
  return buffer;
}



