[System.Reflection.Assembly]::LoadWithPartialName("System.Data") | Out-Null

$connectionString = "Server=localhost;Database=zeetech_db;User Id=sa;Password=123;Encrypt=True;TrustServerCertificate=True;"
$conn = New-Object System.Data.SqlClient.SqlConnection($connectionString)

try {
    $conn.Open()
    $cmd = $conn.CreateCommand()
    
    # Check users table
    $cmd.CommandText = "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'users'"
    $reader = $cmd.ExecuteReader()
    Write-Host "Columns in 'users' table:"
    while ($reader.Read()) {
        Write-Host " - $($reader.GetValue(0))"
    }
    $reader.Close()
    
    Write-Host ""
    
    # Check bookings table
    $cmd.CommandText = "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'bookings'"
    $reader = $cmd.ExecuteReader()
    Write-Host "Columns in 'bookings' table:"
    while ($reader.Read()) {
        Write-Host " - $($reader.GetValue(0))"
    }
    $reader.Close()
    
} catch {
    Write-Error $_.Exception.Message
} finally {
    $conn.Close()
}
