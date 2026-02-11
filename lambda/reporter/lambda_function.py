import json
import boto3
import os
from datetime import datetime

s3 = boto3.client("s3")

BUCKET_NAME = os.environ.get("BUCKET_NAME")


def lambda_handler(event, context):
    try:
        print("Daily reporter triggered")

        # List all processed summary files
        response = s3.list_objects_v2(
            Bucket=BUCKET_NAME,
            Prefix="processed/"
        )

        total_files = 0
        grand_total_records = 0
        grand_total_amount = 0.0

        if "Contents" in response:
            for obj in response["Contents"]:
                key = obj["Key"]

                # Skip folder placeholder
                if key.endswith("/"):
                    continue

                file_data = s3.get_object(Bucket=BUCKET_NAME, Key=key)
                content = file_data["Body"].read().decode("utf-8")
                summary = json.loads(content)

                total_files += 1
                grand_total_records += summary.get("total_records", 0)
                grand_total_amount += summary.get("total_amount", 0.0)

        daily_report = {
            "generated_at": datetime.utcnow().isoformat(),
            "total_files_processed": total_files,
            "grand_total_records": grand_total_records,
            "grand_total_amount": grand_total_amount
        }

        report_key = f"reports/daily_report_{datetime.utcnow().strftime('%Y%m%d')}.json"

        s3.put_object(
            Bucket=BUCKET_NAME,
            Key=report_key,
            Body=json.dumps(daily_report),
            ContentType="application/json"
        )

        print("Daily report generated:", report_key)

        return {
            "statusCode": 200,
            "body": json.dumps("Daily report generated successfully")
        }

    except Exception as e:
        print("Error generating daily report:", str(e))
        raise e
