<#

Run this to merge all the CSVs from Kansa's output into one merged document

WHY? - Because each individual Kansa module has its own unique output directory, so we need to logically seperate the merged output

#>


#FIRST merge all the directories by changing the inputDirectory and outputdirectory file variables, see examples below

$inputDirectories = @(
    "C:\Users\Admin\Desktop\Kansa\Output_new",
    "C:\Users\Admin\Desktop\Kansa\Output_new"
)

#BE SURE to create this directory
$outputDirectory = "C:\Output2"

# Copy directory structure from input directories to $outputDirectory
foreach ($inputDirectory in $inputDirectories) {
    $directoryStructure = Get-ChildItem -Path $inputDirectory -Recurse -Directory
    foreach ($directory in $directoryStructure) {
        $relativePath = $directory.FullName.Substring($inputDirectory.Length)
        $outputPath = Join-Path -Path $outputDirectory -ChildPath $relativePath
        New-Item -Path $outputPath -ItemType Directory -Force | Out-Null
    }
}

# Copy files
foreach ($inputDirectory in $inputDirectories) {
    $files = Get-ChildItem -Path $inputDirectory -Filter *.csv -Recurse
    foreach ($file in $files) {
        $relativePath = $file.DirectoryName.Substring($inputDirectory.Length)
        $outputPath = Join-Path -Path $outputDirectory -ChildPath $relativePath
        Copy-Item -Path $file.FullName -Destination $outputPath
        Write-Host "Copied $($file.FullName) to $($outputPath)"
    }
}

Write-Host "All files copied to the output directory."

Start-Sleep -Seconds 30

#SECOND - run seperately, or just let the sleep thing jive
#This part will take all the aggregated files from disparate file locations and combine all the CSV data into one big CSV
cd $outputDirectory


$Dirrr = $outputDirectory
$fileDirs = Get-ChildItem $Dirrr -Directory | select -ExpandProperty name
$CSV = "C:\Users\outfile\" # forget this variable Change this to your desired output path
$outputFile = "merged.csv"

foreach ($Dir in $fileDirs){
    $files = Get-ChildItem -Path "$Dirrr\$Dir" -Filter *.csv
    foreach ($file in $files) {
        $csvData = Import-Csv $file.FullName
        $csvData | Export-Csv -Path "$Dir-$outputFile" -NoTypeInformation -Append
    }
    Write-Host "$Dir merge complete"
}


