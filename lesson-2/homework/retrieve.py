import pyodbc  # Module for connecting to SQL Server

con_str = "DRIVER={SQL SERVER};SERVER=LAPTOP-7DJ5CTV5;DATABASE=master;Trusted_Connection=yes;"
con = pyodbc.connect(con_str)
cursor = con.cursor()

# Retrieve the image from the database where id = 1
cursor.execute("SELECT image_data FROM photos WHERE id = ?", (1,)) 
row = cursor.fetchone()

# Check if a result was returned and write the binary to a file
if row and row[0]:
    with open("retrieved_image.jpg", "wb") as f:  # Open a file in write-binary mode
        f.write(row[0])                           # Write the binary image data
    print("Image saved as retrieved_image.jpg")
else:
    print("No image found for the specified ID.")

# Close the connection
con.close()
