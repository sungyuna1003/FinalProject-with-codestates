# Budda Palm Project
<div align="center">
<p>DevOps_Bootcamp_Final_Project_Team_D</p>
    <img src="https://img.shields.io/badge/AmazonAWS-232F3E?style=flat-square&logo=AmazonAWS&logoColor=white"/>
    <img src="https://img.shields.io/badge/Terraform-7B42BC?style=flat-square&logo=Terraform&logoColor=white"/>
    <img src="https://img.shields.io/badge/GitHub Actions-2088FF?style=flat-square&logo=GitHub Actions&logoColor=white"/>
    <img src="https://img.shields.io/badge/OpenSearch-005EB8?style=flat-square&logo=OpenSearch&logoColor=white"/>  
    <img src="https://img.shields.io/badge/Python-3776AB?style=flat-square&logo=Python&logoColor=white"/>
<p>소비자에게 화물을 전달하는 드라이버의 실시간 위치 정보를 받아 소비자에게 전달하는 서비스입니다.</p>
</div>     
    

## Getting Started
   
## `방법 1. CLI 에서 구현`
1. main.tf의 cloud - organization, name을 개인 terraform cloud 정보를 수정합니다.
2. variables.tf의 72줄의 amazon_id를 수정합니다.
3. (선택사항) opensearch.tf의 55, 56줄 master_user_name과 master_user_password를 수정합니다.   
   ( Default : `master_user_name : admin`, `master_user_password : Qwer1234` )   
   ( 수정시 request-handler.py의 12줄 Authorization값을 변경해 줘야 합니다. )   
4. terraform login
5. terraform init
6. terraform apply
7. 생성된 lambda - 'terraform-request-lambda'의 9줄 HTTPSConnection("")의 빈칸에   
   opensearch - 'terraform-domain'의 엔드포인트를 넣어줍니다.
8. 생성된 opensearch - 'terraform-domain'의 대시보드에 들어가 Roles - all_access의 Backend roles에   
   `arn:aws:iam::<AWS ID>:role/firehose_role`를 넣어줍니다.   
   
## `방법 2. Github Action`
1. Github - Repository - Settings - Secrets - Actions에 terraform cloud 토큰을 'TF_API_TOKEN'이름으로 넣어줍니다.
2. main.tf의 cloud - organization, name을 개인 terraform cloud 정보를 수정합니다.
3. variables.tf의 72줄의 amazon_id를 수정합니다.
4. (선택사항) opensearch.tf의 55, 56줄 master_user_name과 master_user_password를 수정합니다.   
   ( Default : `master_user_name : admin`, `master_user_password : Qwer1234` )   
   ( 수정시 request-handler.py의 12줄 Authorization값을 변경해 줘야 합니다. )   
4. .github\workflows 폴더에 terraform.yml을 넣어줍니다.
5. ( Action 이후 ) 생성된 lambda - 'terraform-request-lambda'의 9줄 HTTPSConnection("")의 빈칸에   
   opensearch - 'terraform-domain'의 엔드포인트를 넣어줍니다.
6. 생성된 opensearch - 'terraform-domain'의 대시보드에 들어가 Roles - all_access의 Backend roles에   
   `arn:aws:iam::<AWS ID>:role/firehose_role`를 넣어줍니다.   

## Running the tests

## `방법 1. CLI 에서 구현`   
#### terraform init
![image](https://user-images.githubusercontent.com/76947477/171099409-2729c93c-af73-47ec-bb86-7c368ea54d7b.png)

#### terraform apply
![image](https://user-images.githubusercontent.com/76947477/171102394-33326f21-5806-4c52-98fe-28066e7e4dc1.png)


## `방법 2. Github Action`   
#### Github Action
![image](https://user-images.githubusercontent.com/76947477/171099809-1bbd68bc-5ffa-4531-8ebf-d2cc869823f1.png)


## `실행 내용`
![image](https://user-images.githubusercontent.com/76947477/171103156-ac6a3f91-52e5-4088-8234-81d81b275dde.png)
임의의 위치를 지정

![image](https://user-images.githubusercontent.com/76947477/171103196-9f564326-7da6-4dca-9713-9d18ffb4b9ed.png)


## Built With
* [김은아](https://github.com/manok119)
* [김필재](https://github.com/Olatte3)
