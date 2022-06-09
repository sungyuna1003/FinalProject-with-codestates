import json
import http.client
import datetime

date_time_str = datetime.datetime.now()
d = str(date_time_str)
print(d[0:10])

conn = http.client.HTTPSConnection("Example") #your-opensearch-domain ex) <opensearch name>-abcdefghijklnmopqlstuvwxyz.<region>.es.amazonaws.com
payload = ''
headers = {
  'Authorization': 'Basic YWRtaW46UXdlcjEyMzQq' #options
}
conn.request("GET", "/location-index-"+d[0:10]+"/_search?q=truckerId:000000&sort=@timestamp_utc:desc&size=1", payload, headers)
res = conn.getresponse()
data = res.read()
print(data.decode("utf-8"))

def lambda_handler(event, context):
    # TODO implement
    return {
        'statusCode': 200,
        'body': data #json.dumps(data.decode("utf-8"))
    }
