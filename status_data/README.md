# Status data
<div align="left">
    <p>DevOps_Bootcamp_Final_Project_Team_D</p>
    <img src="https://img.shields.io/badge/AmazonAWS-F01F7A?style=flat-square&logo=AmazonAWS&logoColor=white"/>
    <img src="https://img.shields.io/badge/Terraform-7B42BC?style=flat-square&logo=Terraform&logoColor=white"/>
    <img src="https://img.shields.io/badge/GitHub Actions-2088FF?style=flat-square&logo=GitHub Actions&logoColor=white"/>
    <img src="https://img.shields.io/badge/NodeJS-brightgreen?style=flat-square&logo=Node.js&logoColor=white"/>
<p>드라이버의 상태(출발 및 도착)정보를 받아 소비자에게 전달하는 서비스입니다.</p>
</div>

# 파일 설명

| Command | Description                                    |
| ---------- | ---------------------------------------------- |
| main |  terraform cloud를 사용하기 위한 tf 파일      |
| apigatway-status-lambda |  apigatway와 status-lambda 를 연결하기 위한 tf 파일           |
| dynamoDB |  DynamoDB를 생성하기 위한 tf 파일           |
| status-lambda |  상태 메세지를 dynamoDB로 보내기 위한 람다                 |
| status-lambda-iam | status-lambda에서 DynamoDB를 접근하기 위한 IAM-ROLE 권한                   |
| hook-lambda | DynamoDB 트리거를 통해 디스코드로 상태 메세지를 보내기 위한 람다       |
| hook-lambda-iam | hook-lambda에서 DynamoDB를 접근하기 위한 IAM-ROLE 권한                 |
| statuslambda-handler| satus-lambda에서 사용할 js 파일|
| hooklambda-handler|hook-lambda에서 사용할 js파일과 모듈파일|
| files| 람다js 자동배포를 위한 archive_file|

# 사용한 라이브러리

### aws-sdk

설치 명령어 입니다.

```
npm install aws-sdk
```

### axios

설치 명령어 입니다.

```
npm install axios
```


## Getting Started 
1. main.tf의 cloud - organization, name을 개인 terraform cloud 정보를 수정합니다.
2. terraform.yml를 .github\workflows로 위치를 변경합니다
3. secrets.TF_API_TOKEN 값을 발급받고 넣어줍니다. [참고1](https://learn.hashicorp.com/tutorials/terraform/cloud-login)
4. (Console) 콘솔상으로 실행을 할려면 다음 콘솔명령어를 실행합니다.
```
terraform login
terraform init
terraform apply
```
5. (GitActions)자동으로 배포가 가능합니다. 파일을 수정하여 GIT으로 push하면 GitActions가 실행됩니다.
![4](https://user-images.githubusercontent.com/67503900/171121876-54fb1f8a-677d-41ea-9c24-0c1ea5b06b34.JPG)

## 실행 내용
출발했을때의 예시 데이터 PUT {대기상태:0,출발:1,도착2:}

![3](https://user-images.githubusercontent.com/67503900/171121992-3e1cc170-65e6-479b-b53c-2673d84c3792.JPG)

데이터가 통과했을때의 WEBHOOK

![5](https://user-images.githubusercontent.com/67503900/171122306-07fd7b42-df30-432a-b1d0-b39e6e51a0df.JPG)

## Clean up
```
terraform destroy
```
