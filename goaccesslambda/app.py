import subprocess
import json

def lambda_handler(event, context):

    print(subprocess.run(["/apps/execute.sh",
                "arguments"], shell=True))

    return {
        'statusCode': 200,
        'body': json.dumps('goAccess ececuted successfully')
    }