# -------------------------------------------------------
# Copyright (c) [2022] Nadege Lemperiere
# All rights reserved
# -------------------------------------------------------
# Keywords to create data for module test
# -------------------------------------------------------
# Nadège LEMPERIERE, @13 november 2021
# Latest revision: 13 november 2021
# -------------------------------------------------------

# System includes
from json import load, dumps

# Robotframework includes
from robot.libraries.BuiltIn import BuiltIn, _Misc
from robot.api import logger as logger
from robot.api.deco import keyword
ROBOT = False

# ip address manipulation
from ipaddress import IPv4Network

@keyword('Load Multiple Test Data')
def load_multiple_test_data(ids, arns, key, region) :

    result = {}
    result['tables'] = []

    if len(ids) != 2 : raise Exception(str(len(ids)) + ' tables created instead of 2')

    for i in range(1,2) :
        table = {}
        table['TableName'] = 'test-test-' + region + '-test-' + str(i)
        table['AttributeDefinitions'] = [{'AttributeName' : 'LockID', 'AttributeType' : 'S'}]
        table['ItemCount'] = 0
        table['KeySchema'] = [{'AttributeName' : 'LockID', 'KeyType' : 'HASH'}]
        table['TableStatus'] = 'ACTIVE'
        table['TableArn'] = arns[i - 1]
        table['SSEDescription'] = {'Status' : 'ENABLED', 'SSEType' : 'KMS', 'KMSMasterKeyArn': key[i - 1] }

        if i == 1 : table['ProvisionedThroughput'] = {'ReadCapacityUnits': 5, 'WriteCapacityUnits': 5}
        elif i == 2 : table['ProvisionedThroughput'] = {'ReadCapacityUnits': 1, 'WriteCapacityUnits': 1}

        table['Tags'] = []
        table['Tags'].append({'Key'        : 'Version'             , 'Value' : 'test'})
        table['Tags'].append({'Key'        : 'Project'             , 'Value' : 'test'})
        table['Tags'].append({'Key'        : 'Module'              , 'Value' : 'test'})
        table['Tags'].append({'Key'        : 'Environment'         , 'Value' : 'test'})
        table['Tags'].append({'Key'        : 'Owner'               , 'Value' : 'moi.moi@moi.fr'})
        table['Tags'].append({'Key'        : 'Name'                , 'Value' : 'test.test.test.' + region + '.test-' + str(i) + '.table'})

        result['tables'].append({'name' : 'test-' + str(i), 'data' : table})

    logger.debug(dumps(result))

    return result