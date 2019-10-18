#!/bin/bash

source ./config

echo -------------------------------------- 
if [ ${Language} = "JA" ] ; then
    echo "01. PHPコードインジェクション攻撃 (保護ルールID-950002)"
    echo
    echo 以下のPHPインジェクション攻撃コマンドを10回実行します。
else
    echo "01. php code injection (protection rule-950002)"
    echo
    echo Executing following "php injected" command
fi
echo "curl -lvk -verbose http://${WAFSecuredHost}/${VulnerabilityPath}/?a=telnet.exe"
echo --------------------------------------
read -p "ENTERキーを押してください: "
curl -lvk -verbose http://${WAFSecuredHost}/${VulnerabilityPath}/?a=telnet.exe
curl -lvk -verbose http://${WAFSecuredHost}/${VulnerabilityPath}/?a=telnet.exe
curl -lvk -verbose http://${WAFSecuredHost}/${VulnerabilityPath}/?a=telnet.exe
curl -lvk -verbose http://${WAFSecuredHost}/${VulnerabilityPath}/?a=telnet.exe
curl -lvk -verbose http://${WAFSecuredHost}/${VulnerabilityPath}/?a=telnet.exe
curl -lvk -verbose http://${WAFSecuredHost}/${VulnerabilityPath}/?a=telnet.exe
curl -lvk -verbose http://${WAFSecuredHost}/${VulnerabilityPath}/?a=telnet.exe
curl -lvk -verbose http://${WAFSecuredHost}/${VulnerabilityPath}/?a=telnet.exe
curl -lvk -verbose http://${WAFSecuredHost}/${VulnerabilityPath}/?a=telnet.exe
curl -lvk -verbose http://${WAFSecuredHost}/${VulnerabilityPath}/?a=telnet.exe
echo
echo --------------------------------------
if [ ${Language} = "JA" ] ; then
    echo "攻撃が完了しました。"
    echo
    echo "HTTPレスポンスコードが403の場合は、WAFによってトラフィックがブロックされたことを示しています。WAFを検出のみに設定している場合は、オリジンサーバー(Webサーバー)までトラフィックが到達するため、レスポンスコードが200になります。"
	echo
	echo "また、HTTPレスポンスの中の *.ZENEDGE という表示は、攻撃したトラフィックが Oracle Cloud Infrastructure (OCI) の Webアプリケーション・ファイアウォール (WAF) を経由してオリジン・サーバー (Webサーバー) と通信していることを示しています。"
    echo
    echo "OCI コンソールの WAF ポリシーのページにアクセスし、ログに出力されている攻撃の詳細を確認してください。"
else
    echo "http response code #200 in the above command output with *.ZENEDGE indicates the traffic has successfully traversed through Oracle Cloud Infrastructure(O.C.I) Web Application Firewall (W.A.F.) to the origin web server"
    echo
    echo "Next Step: Please visit to your respective WAF Policy and click on logs to observe the details of the attack."
fi
echo --------------------------------------
