[System.Reflection.Assembly]::LoadWithPartialName("System.Data") | Out-Null

$connectionString = "Server=localhost;Database=zeetech_db;User Id=sa;Password=123;Encrypt=True;TrustServerCertificate=True;"
$conn = New-Object System.Data.SqlClient.SqlConnection($connectionString)

try {
    $conn.Open()
    $cmd = $conn.CreateCommand()
    
    Write-Host "Updating 'users' table schema..."
    try {
        $cmd.CommandText = "ALTER TABLE users ADD specialty VARCHAR(255) NULL"
        $cmd.ExecuteNonQuery()
        Write-Host " - Added column 'specialty' successfully."
    } catch {
        if ($_.Exception.Message -like "*already*") {
            Write-Host " - Column 'specialty' already exists."
        } else {
            Write-Error "Error adding column 'specialty': $($_.Exception.Message)"
        }
    }
    
    Write-Host "`nUpdating 'bookings' table schema..."
    
    # 1. assigned_worker
    try {
        $cmd.CommandText = "ALTER TABLE bookings ADD assigned_worker VARCHAR(255) NULL"
        $cmd.ExecuteNonQuery()
        Write-Host " - Added column 'assigned_worker' successfully."
    } catch {
        if ($_.Exception.Message -like "*already*") {
            Write-Host " - Column 'assigned_worker' already exists."
        } else {
            Write-Error "Error adding column 'assigned_worker': $($_.Exception.Message)"
        }
    }
    
    # 2. started_at
    try {
        $cmd.CommandText = "ALTER TABLE bookings ADD started_at DATETIME2 NULL"
        $cmd.ExecuteNonQuery()
        Write-Host " - Added column 'started_at' successfully."
    } catch {
        if ($_.Exception.Message -like "*already*") {
            Write-Host " - Column 'started_at' already exists."
        } else {
            Write-Error "Error adding column 'started_at': $($_.Exception.Message)"
        }
    }
    
    # 3. completed_at
    try {
        $cmd.CommandText = "ALTER TABLE bookings ADD completed_at DATETIME2 NULL"
        $cmd.ExecuteNonQuery()
        Write-Host " - Added column 'completed_at' successfully."
    } catch {
        if ($_.Exception.Message -like "*already*") {
            Write-Host " - Column 'completed_at' already exists."
        } else {
            Write-Error "Error adding column 'completed_at': $($_.Exception.Message)"
        }
    }
    
    # 4. work_summary
    try {
        $cmd.CommandText = "ALTER TABLE bookings ADD work_summary VARCHAR(MAX) NULL"
        $cmd.ExecuteNonQuery()
        Write-Host " - Added column 'work_summary' successfully."
    } catch {
        if ($_.Exception.Message -like "*already*") {
            Write-Host " - Column 'work_summary' already exists."
        } else {
            Write-Error "Error adding column 'work_summary': $($_.Exception.Message)"
        }
    }
    
    Write-Host "`nDatabase update completed successfully!"
    
} catch {
    Write-Error "General Database error: $($_.Exception.Message)"
} finally {
    $conn.Close()
}
