# Budda Palm Project
![finaldiagram](https://user-images.githubusercontent.com/96624366/171095858-7d9057a1-b9b7-4cd1-972b-6690c36fadb4.png)

# Main Subject - Cargo Deliver Loacation Tracking System 
국내 1등 화물 운송 서비스 업체의 화물운송위치 추적 시스템  
예약이 완료된 고객은 소중한 자산을 운송하고 있는 화물차의 위치상태를 확인할 수 있어야 합니다.    
실시간으로 전달되는 화물차의 위치정보를 고객에게 정확하게 전달되도록 하는 시스템을 구현하는 것이 이 프로젝트의 목표입니다. 

## Getting Started

AWS Cloud 기반 서비스를 이용하여 서버리스로 데이터의 처리하기 때문에 기본적인 AWS계정이 필요하고,   
Infra As Code 구현을 위한 Terraform 작업환경이 갖추어 져야 합니다. 

1. **Sign up for AWS** &mdash; Before you begin, you need an AWS account. For more information about creating an AWS account and retrieving your AWS credentials, see [AWS Account and Credentials][docs-signup] in the AWS SDK for Java Developer Guide.
1. **Sign up for Amazon Kinesis** &mdash; Go to the Amazon Kinesis console to sign up for the service and create an Amazon Kinesis stream. For more information, see [Create an Amazon Kinesis Stream][kinesis-guide-create] in the Amazon Kinesis Developer Guide.
1. **Install Terraform** &mdash; https://www.terraform.io/intro


## Amazon Webservices / Api-gateway, Lambda, Kinesis, Opensearch Service, DynamoBD
[![Build Status](https://travis-ci.org/awslabs/amazon-kinesis-client.svg?branch=master)](https://travis-ci.org/awslabs/amazon-kinesis-client)

The **Amazon Kinesis Client Library for Java** (Amazon KCL) enables Java developers to easily consume and process data from [Amazon Kinesis][kinesis].

* [Kinesis Product Page][kinesis]
* [Forum][kinesis-forum]
* [Issues][kinesis-client-library-issues]




## Terraform Provider for AWS

[![Forums][discuss-badge]][discuss]

[discuss-badge]: https://img.shields.io/badge/discuss-terraform--aws-623CE4.svg?style=flat
[discuss]: https://discuss.hashicorp.com/c/terraform-providers/tf-aws/

- Website: [terraform.io](https://terraform.io)
- Tutorials: [learn.hashicorp.com](https://learn.hashicorp.com/terraform?track=getting-started#getting-started)
- Forum: [discuss.hashicorp.com](https://discuss.hashicorp.com/c/terraform-providers/tf-aws/)
- Chat: [gitter](https://gitter.im/hashicorp-terraform/Lobby)
- Mailing List: [Google Groups](http://groups.google.com/group/terraform-tool)





### Installing 

아래 사항들로 현 프로젝트에 관한 모듈들을 설치할 수 있습니다.

```
1. aws-cli 설치
https://docs.aws.amazon.com/ko_kr/cli/latest/userguide/getting-started-install.html

```

## 마이크로서비스

마이크로서비스는 분산형 개발을 통해 팀의 역량과 일상적인 업무 능력을 향상시킵니다. 또한, 동시에 여러 마이크로서비스를 개발하는 것도 가능합니다. 다시 말해, 동일한 애플리케이션 개발에 더 많은 개발자들이 동시 참여할 수 있으므로 개발에 소요되는 시간을 단축할 수 있습니다.이 프로젝트에서는 데이터의 유형을 화물차의 status data와 화물차의 실시간 location data로 구분하여 마이크로서비스 작업을 진행하였습니다. 

### /Location data - 해당 디렉토리  read me 참조
### /Status data - 해당 디렉토리 read me 참조


## 테스트 
K6 프로그램을 활용한 데이터 전송 테스트 
3초에 한번씩 위치 정보를 전송하는 시나리오로 테스트 실시

### Install K6
-------

### Mac

Install with [Homebrew](https://brew.sh/) by running:

```bash
brew install k6
```

### Windows

If you use the [Chocolatey package manager](https://chocolatey.org/) you can install the unofficial k6 package with:

```
choco install k6
```

Otherwise, you can manually download and install the [latest official `.msi` package](https://dl.k6.io/msi/k6-latest-amd64.msi).

### Linux

For Debian-based Linux distributions like Ubuntu, you can install k6 from the private deb repo like this:

```bash
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C5AD17C747E3415A3642D57D77C6C491D6AC1D69
echo "deb https://dl.k6.io/deb stable main" | sudo tee /etc/apt/sources.list.d/k6.list
sudo apt-get update
sudo apt-get install k6
```

If you have issues adding the key from the keyserver, you can instead run:
```bash
curl -s https://dl.k6.io/key.gpg | sudo apt-key add -
```

Then confirm that the key with the above ID is shown in the output of `sudo apt-key list`.

And for rpm-based ones like Fedora and CentOS:

```bash
sudo dnf install https://dl.k6.io/rpm/repo.rpm    # use yum instead of dnf for older distros
sudo dnf install k6    # use yum install --nogpgcheck k6 for older distros (e.g. CentOS 7) without PGP V4 signature support
```
### Running k6
----------

k6 works with the concept of **virtual users** (VUs) that execute scripts - they're essentially glorified, parallel `while(true)` loops. Scripts are written using JavaScript as ES6 modules, which allows you to break larger tests into smaller and more reusable pieces, making it easy to scale tests across an organization.

Scripts must contain, at the very least, an exported `default` function - this defines the entry point for your VUs, similar to the `main()` function in many languages. Let's create a very simple script that makes an HTTP GET request to a test website:

```js
import http from "k6/http";

export default function() {
    let response = http.get("https://test-api.k6.io");
};
```

## Deployment / 배포 
### CLI 및 Github Action을 통한 배포자동화        
      
## Built With 

* [김준형](https://github.com/lightcow) - status data의 인프라 코딩 작업
* [김필재](https://github.com/Olatte3) - location data의 서버리스 및 인프라 코딩 및 자동화 작업
* [성유나](https://github.com/sungyuna1003) - status data 테스트 환경 조성
* [김은아](https://github.com/manok119)- location data의 서버리스 컴퓨팅 작업 및 api-gateway 작업


## License / 라이센스

This project is licensed under the Codestates License   
이 프로젝트는 Codestates 라이센스로 라이센스가 부여되어 있습니다. 

## Acknowledgments 

* 마이크로서비스를 기준으로 디렉토리가 구성되어있습니다. 
* 부처님 손바닥안에서 보는 것 처럼 고객이 화물차의 위치를 잘 알 수 있도록 서비스를 만들고자 프로젝트 이름을 Budda Palm이라고 하였습니다. 
# FinalProject-with-codestates
