#!/bin/sh

APISERVER=https://kubernetes.default.svc.cluster.local
SERVICEACCOUNT=/var/run/secrets/kubernetes.io/serviceaccount
TOKEN=$(cat ${SERVICEACCOUNT}/token)
CACERT=${SERVICEACCOUNT}/ca.crt

echo "Checking ${MON_APP} pod in ${MON_NS} namespace on ${NODE} node"

while true
do
    echo "Querying API server..."
    echo ""

    responseJson=$(curl -s --cacert ${CACERT} --header "Authorization: Bearer ${TOKEN}" -X GET ${APISERVER}/api/v1/namespaces/${MON_NS}/pods)
    
    podJson=$(echo ${responseJson} | jq --arg NODE "$NODE" --arg MON_APP "$MON_APP" '.items[] | select ( .spec.nodeName | contains($NODE)) | select ( .metadata.name | contains($MON_APP))')
    echo "Pod extracted:"
    echo "${podJson}"
    echo ""

    containerStatus=$(echo ${responseJson} | jq --arg NODE "$NODE" --arg MON_APP "$MON_APP" --arg MON_CONTAINER "$MON_CONTAINER"  '.items[] | select ( .spec.nodeName | contains($NODE)) | select ( .metadata.name | contains($MON_APP)) | .status.containerStatuses[] | select ( .name==$MON_CONTAINER) | .ready')
    echo "Container status: ${containerStatus}"
    echo ""

    if [ "$containerStatus" == "true" ]
    then
    echo "Container ${MON_CONTAINER} is ready"
    echo "Exiting..."
    exit 0
    fi

    sleep 5

done  