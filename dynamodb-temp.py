import boto3
import json
import logging
import time
from boto3.dynamodb.conditions import Key, Attr
from pyzabbix import ZabbixAPI

zapi = ZabbixAPI("http://zabbixurl/")
zapi.login("<user>", "<password>")
print("Connected to Zabbix API Version %s" % zapi.api_version())


logger = logging.getLogger()
logger.setLevel(logging.DEBUG)

route53 = boto3.client('route53')
ec2 = boto3.resource('ec2', region_name='eu-west-1')
dynamodb = boto3.resource('dynamodb', region_name='eu-west-1')

table = dynamodb.Table('delete_hosts')


## zabbix get host id
def get_host_by_ip(ip):
    interface = zapi.hostinterface.get(
        {"output": "extend",
         "sortfield": "interfaceid"})
    for i in interface:
        if i['ip'] == ip:  # If we found ip
             #   print i['hostid']
                 return i['hostid']

##zabvbix delete the host from zabbix

def delete_hosts(hostid):
    result=zapi.host.delete(hostid)

# insert host into db
def insert_host(host_id, time, private_ip):
    response = table.put_item(
        Item={
            'host_id': host_id,
            'time': time,
            'private_ip': private_ip,
        }
    )
    print response

#TODO
# change all prints to log outputs
# need to add delete the record from the mongodb


def DynamoDB_delete_host(host_id,private_ip):
    response=table.delete_item(
        Key={
            'host_id': host_id,
        },
        ConditionExpression = fe,

    )
    print response



#get the ip then get the hostid and delet the host

val1="2018-01-14"
# val2="2018-01-14T00:00:00"
# #def get_hostlist_from_dynamodb():
# # test='01af7e917ee96808a'
# #fe = Key('time').between('2018-01-13T00:00:00', '2018-01-14T00:00:00');
fe = Key('time').gt(val1);
# pe="host_id,private_ip'"
# response=table.scan(FilterExpression=fe)
# count=response['Count']
# if count==0:
#     print "no Items tro delete - no work for me!!!"
# else:
#     print "there are ", count , "instances to delete"
#     for i in response['Items']:
#        try:
#            i['private_ip']
#            myip=i['private_ip']
#            print myip
#            ZabbixHostID=get_host_by_ip(myip)
#            print  "going to delete hostid: ", ZabbixHostID, "with ip :" ,myip #change to log
#            delete_hosts(ZabbixHostID)
#            print "host was deleted"
#
#        except KeyError:
#             print "no ip found"
#             pass

DynamoDB_delete_host()
