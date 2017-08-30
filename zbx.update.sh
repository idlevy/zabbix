#!/usr/bin/bash
#script  to enable/disable/delete hosts from zabbix.
# zbx.update.sh enbale|disbale|delete  <hostname>


HOST_NAME=$2
disable() {

        USER='Admin'
        PASS='zabbix'
        ZABBIX_SERVER='localhost'
        API='http://localhost/zabbix/api_jsonrpc.php'

        # Authenticate with Zabbix API

        authenticate() {
                echo `curl -s -H  'Content-Type: application/json-rpc' -d "{\"jsonrpc\": \"2.0\",\"method\":\"user.login\",\"params\":{\"user\":\""${USER}"\",\"password\":\""${PASS}"\"},\"auth\": null,\"id\":0}" $API`
        }

        AUTH_TOKEN=`echo $(authenticate)|jq -r .result`

        # Get This Host HostId:

        gethostid() {
               echo `curl -s -H 'Content-Type: application/json-rpc' -d "{\"jsonrpc\": \"2.0\",\"method\":\"host.get\",\"params\":{\"output\":\"extend\",\"filter\":{\"host\":[\""$HOST_NAME"\"]}},\"auth\":\""${AUTH_TOKEN}"\",\"id\":0}" $API`
        }

        HOST_ID=`echo $(gethostid)|jq -r .result[0].hostid`

        # disable Host

        disable_host() {
                echo `curl -s -H 'Content-Type: application/json-rpc' -d "{\"jsonrpc\": \"2.0\",\"method\":\"host.update\",\"params\":{\"hostid\":\"${HOST_ID}\",\"status\":\"1\"},\"auth\":\""${AUTH_TOKEN}"\",\"id\":0}" http://localhost/zabbix/api_jsonrpc.php`
        }
        RESPONSE=$(disable_host)
        echo ${RESPONSE}
}

delete() {

        USER='Admin'
        PASS='zabbix'
        ZABBIX_SERVER='localhost'
        API='http://localhost/zabbix/api_jsonrpc.php'

        # Authenticate with Zabbix API

        authenticate() {
                echo `curl -s -H  'Content-Type: application/json-rpc' -d "{\"jsonrpc\": \"2.0\",\"method\":\"user.login\",\"params\":{\"user\":\""${USER}"\",\"password\":\""${PASS}"\"},\"auth\": null,\"id\":0}" $API`
        }

        AUTH_TOKEN=`echo $(authenticate)|jq -r .result`

        # Get This Host HostId:

        gethostid() {
               echo `curl -s -H 'Content-Type: application/json-rpc' -d "{\"jsonrpc\": \"2.0\",\"method\":\"host.get\",\"params\":{\"output\":\"extend\",\"filter\":{\"host\":[\""$HOST_NAME"\"]}},\"auth\":\""${AUTH_TOKEN}"\",\"id\":0}" $API`
        }

        HOST_ID=`echo $(gethostid)|jq -r .result[0].hostid`
       # remove Host
             remove_host() {
                echo `curl -s -H 'Content-Type: application/json-rpc' -d "{\"jsonrpc\": \"2.0\",\"method\":\"host.delete\",\"params\":[\""${HOST_ID}"\"],\"auth\":\""${AUTH_TOKEN}"\",\"id\":0}" $API`
        }
        RESPONSE=$(remove_host)
        echo ${RESPONSE}
}


enable() {

        USER='Admin'
        PASS='zabbix'
        ZABBIX_SERVER='localhost'
        API='http://localhost/zabbix/api_jsonrpc.php'

        # Authenticate with Zabbix API

        authenticate() {
                echo `curl -s -H  'Content-Type: application/json-rpc' -d "{\"jsonrpc\": \"2.0\",\"method\":\"user.login\",\"params\":{\"user\":\""${USER}"\",\"password\":\""${PASS}"\"},\"auth\": null,\"id\":0}" $API`
        }

        AUTH_TOKEN=`echo $(authenticate)|jq -r .result`

        # Get This Host HostId:

        gethostid() {
               echo `curl -s -H 'Content-Type: application/json-rpc' -d "{\"jsonrpc\": \"2.0\",\"method\":\"host.get\",\"params\":{\"output\":\"extend\",\"filter\":{\"host\":[\""$HOST_NAME"\"]}},\"auth\":\""${AUTH_TOKEN}"\",\"id\":0}" $API`
        }

        HOST_ID=`echo $(gethostid)|jq -r .result[0].hostid`
		
		#anable host
		
        enable_host() {
                echo `curl -s -H 'Content-Type: application/json-rpc' -d "{\"jsonrpc\": \"2.0\",\"method\":\"host.update\",\"params\":{\"hostid\":\"${HOST_ID}\",\"status\":\"0\"},\"auth\":\""${AUTH_TOKEN}"\",\"id\":0}" http://localhost/zabbix/api_jsonrpc.php`
        }
        RESPONSE=$(enable_host)
        echo ${RESPONSE}
}

case $1 in

        disable)
          disable
        ;;

        delete)
          delete
        ;;

        enable)
          enable
        ;;



esac    
exit 0
