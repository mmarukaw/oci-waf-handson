#!/bin/bash

source ./config

echo -------------------------------------- 
if [ ${Language} = "JA" ] ; then
    echo "03. クラシックSQLインジェクション攻撃 (保護ルールID-942000)"
    echo
    echo 以下のSQLインジェクション攻撃のコマンドを10回実行します。
else
    echo "03. Classic SQL injection probing (protection rule-942000)"
    echo
    echo Executing following SQL injection attacking command
fi
echo "curl -lvk -verbose http://${WAFSecuredHost}/${VulnerabilityPath}/?a=%22like%223¥¥¥¥x27"
echo --------------------------------------
read -p "ENTERキーを押してください: "
curl -lvk -verbose http://${WAFSecuredHost}/${VulnerabilityPath}/?a=%22like%223¥¥¥¥x27
curl -lvk -verbose http://${WAFSecuredHost}/${VulnerabilityPath}/?a=%22like%223¥¥¥¥x27
curl -lvk -verbose http://${WAFSecuredHost}/${VulnerabilityPath}/?a=%22like%223¥¥¥¥x27
curl -lvk -verbose http://${WAFSecuredHost}/${VulnerabilityPath}/?a=%22like%223¥¥¥¥x27
curl -lvk -verbose http://${WAFSecuredHost}/${VulnerabilityPath}/?a=%22like%223¥¥¥¥x27
curl -lvk -verbose http://${WAFSecuredHost}/${VulnerabilityPath}/?a=%22like%223¥¥¥¥x27
curl -lvk -verbose http://${WAFSecuredHost}/${VulnerabilityPath}/?a=%22like%223¥¥¥¥x27
curl -lvk -verbose http://${WAFSecuredHost}/${VulnerabilityPath}/?a=%22like%223¥¥¥¥x27
curl -lvk -verbose http://${WAFSecuredHost}/${VulnerabilityPath}/?a=%22like%223¥¥¥¥x27
curl -lvk -verbose http://${WAFSecuredHost}/${VulnerabilityPath}/?a=%22like%223¥¥¥¥x27
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
