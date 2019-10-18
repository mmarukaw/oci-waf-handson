#!/bin/bash

source ./config

echo -------------------------------------- 
if [ ${Language} = "JA" ] ; then
    echo "06. レイヤー7 DDoS攻撃 - Distributed Denial of Service - Apache Benchmark"
    echo0
    echo "以下の Apache Benchmark コマンドを実行し、サイトに対して1000回のクエリを実行します。"
    echo "ab -v 2 -n 1000 -c 100 http://${WAFSecuredHost}/"
    echo "コマンドが完了するまでに 2〜3分程度かかります。"
    echo "もしシステムが無応答状態になった場合は、"Control+C" ボタンを押してコマンドプロンプトを終了してください。"

else
    echo "06. Layer7-DDoS-Distributed Denial of Service - Apache Benchmark"
    echo
    echo "Executing following apache benchmark command"
    echo "ab -v 2 -n 1000 -c 100 http://${WAFSecuredHost}/"
    echo "The command execution will take about 2 to 3 minutes. "
    echo "Please be patient!!"
    echo "If the system hangs, close the command prompt using "Control+C" following by "Y""
fi
echo --------------------------------------
read -p "ENTERキーを押してください: "
# cd ./ApacheBenchmark-Tool/httpd-2.4.39-win64-VC15/Apache24/bin
ab -v 2 -n 1000 -c 100 http://${WAFSecuredHost}/
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
