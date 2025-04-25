-- Creating a table named 'photos' with two columns:
-- 1. 'id': an integer primary key that auto-increments
-- 2. 'image_data': stores the image in binary format
DROP TABLE IF EXISTS photos
CREATE TABLE photos (
    id INT PRIMARY KEY IDENTITY,   -- Identity will increase and auto fill rows in number
    image_data VARBINARY(MAX)
);

-- Insert the image as binary data using OPENROWSET
-- Replace the file path with the path to your image
INSERT INTO photos (image_data)
SELECT * 
FROM OPENROWSET(
    BULK N'C:\Users\acer nitro\OneDrive\Desktop\Application\Images\IMG_white_.JPG',  -- Path of the image
    SINGLE_BLOB                        -- Load the entire file as one binary object
) AS ImageSource;

