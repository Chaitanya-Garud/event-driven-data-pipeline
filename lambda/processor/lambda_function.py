import json
import boto3
import os
import csv
from io import StringIO
from datetime import datetime

s3 = boto3.client("s3")

BUCKET_NAME = os.environ.get("BUCKET_NAME")


def lambda_handler(event, context):
    try:
        print("Event received:", json.dumps(event))

        # Get uploaded file details from S3 event
        record = event["Records"][0]
        bucket_name = record["s3"]["bucket"]["name"]
        object_key = record["s3"]["object"]["key"]

        print(f"Processing file: {object_key}")

        # Read file from S3
        response = s3.get_object(Bucket=bucket_name, Key=object_key)
        content = response["Body"].read().decode("utf-8")

        csv_reader = csv.DictReader(StringIO(content))

        total_records = 0
        total_amount = 0.0

        for row in csv_reader:
            total_records += 1
            if "amount" in row and row["amount"]:
                total_amount += float(row["amount"])

        summary_data = {
            "file_name": object_key,
            "processed_at": datetime.utcnow().isoformat(),
            "total_records": total_records,
            "total_amount": total_amount
        }

        summary_key = f"processed/summary_{datetime.utcnow().strftime('%Y%m%d_%H%M%S')}.json"

        s3.put_object(
            Bucket=BUCKET_NAME,
            Key=summary_key,
            Body=json.dumps(summary_data),
            ContentType="application/json"
        )

        print("Summary saved successfully:", summary_key)

        return {
            "statusCode": 200,
            "body": json.dumps("File processed successfully")
        }

    except Exception as e:
        print("Error processing file:", str(e))
        raise e
