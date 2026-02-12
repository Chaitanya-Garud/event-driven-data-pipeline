#!/bin/bash
set -e

echo "Packaging Lambda functions..."

ROOT_DIR=$(pwd)

mkdir -p lambda

echo "Packaging processor lambda..."
cd lambda/processor
zip -r ../processor.zip .
cd "$ROOT_DIR"

echo "Packaging reporter lambda..."
cd lambda/reporter
zip -r ../reporter.zip .
cd "$ROOT_DIR"

echo "Lambda packaging completed successfully!"

ls -lh lambda
