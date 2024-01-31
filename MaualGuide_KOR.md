# 메뉴얼 가이드 (한국어)

- 해당 매뉴얼은 **서버를 호출하는 Client 측에 필요한 작업**입니다.

## 루트 인증서 조회
```bash
$ keytool -keystore "JAVA Home 경로/jre/lib/security/cacerts" -list -v -storepass changeit
```

- 위 명령어 입력 시 cacerts에 저장 되어있는 루트인증서 전체 목록이 표시됩니다. 해당 출력 내용을 확인하여 첨부된 루트인증서가 없는 경우 아래 명령어를 통해 추가해주시면 됩니다.
 
## 루트 인증서 추가
```bash
$ keytool -import -keystore "JAVA Home 경로/jre/lib/security/cacerts" -file "루트인증서경로 및 파일명" -alias "루트인증서구분용이름" -storepass changeit
```

- 해당 cacerts는 Java 환경에서 기본 지정되어 접근되는 경로여야 합니다.
 
## 루트 인증서 추가 예시
```bash
$ keytool -import -keystore cacerts -file "OISTE WISeKey Global Root GB CA.pem" -alias "oistewisekeyglobalrootgbca" -storepass changeit
```