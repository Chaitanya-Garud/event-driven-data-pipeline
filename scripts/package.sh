#!/bin/bash

echo "Packaging Lambda functions..."

cd "$(dirname "$0")/.." || exit

# Remove old zip files
rm -f lambda/processor.zip
rm -f lambda/reporter.zip

echo "Creating processor.zip..."
powershell Compress-Archive -Path lambda/processor/* -DestinationPath lambda/processor.zip

echo "Creating reporter.zip..."
powershell Compress-Archive -Path lambda/reporter/* -DestinationPath lambda/reporter.zip

echo "Lambda packaging completed successfully!"
