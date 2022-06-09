import http from 'k6/http';
import { sleep, check } from 'k6';
import { Counter } from 'k6/metrics';

// A simple counter for http requests

export const requests = new Counter('http_reqs');

// you can specify stages of your test (ramp up/down patterns) through the options object
// target is the number of VUs you are aiming for

export const options = {
  scenarios: {
    constant_request_rate: {
      executor: 'constant-arrival-rate',
      rate: 1,
      timeUnit: '3s',
      duration: '10m',
      preAllocatedVUs: 600,
      maxVUs: 1000,
    },
  },
  
  thresholds: {
    requests: ['count < 600'],
  },
};


export default function () {
  // our HTTP request, note that we are saving the response to res, which can be accessed later
  const payload = JSON.stringify({
    "truckerId": "000000",
    "@timestamp_utc": "2022-05-17T08:02:55.567Z",
    "location": {
      "lat": 37.3044668,
      "lon": 127.0422522}
  });
  const url = '<API-GATEWAY 엔드포인트>' // 주소 바꿔주세요
  const headers = {
    'Content-Type': 'application/json',
    'dataType': 'json'
  };
  const res = http.request('PUT', '<API-GATEWAY 엔드포인트>', // 주소 바꿔주세요
  payload,  {
    headers: headers,
  });
  console.log(JSON.stringify(payload))
  sleep(0.1);

  const checkRes = check(res, {
    'status is 200': (r) => r.status === 200, // 기대한 HTTP 응답코드인지 확인합니다. 
    'response body': (r) => r.body.indexOf('{"message":"Message accepted!"}') !== -1,  // 기대한 응답인지 확인합니다. 
  });
   
  const params = {
    headers: {
      'Content-Type': 'application/json',
    },
  };
  http.put(url, payload, params);

}






