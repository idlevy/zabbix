from pyzabbix import ZabbixAPI

zapi = ZabbixAPI("http://zabbixIP/zabbix")
zapi.login("user", "pw")
print("Connected to Zabbix API Version %s" % zapi.api_version())




count=0
result2 = zapi.do_request('host.get',
                          {
                              'filter': {'status': 0},
                              'output': 'extend'
                          })
for i in result2['result']:
    #print i

    if "Interrupted" in i['error'] and "10" in i['host']:
        hostid=i['hostid']
        print hostid , i['host']
        result=zapi.host.delete(hostid)
        print result
        count+=1

print count , "hosts were deleted."
