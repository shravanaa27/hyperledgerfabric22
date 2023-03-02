#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.json
}

function yaml_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}

ORG=sro
P0PORT=7051
CAPORT=7054
PEERPEM=organizations/peerOrganizations/sro.example.com/tlsca/tlsca.sro.example.com-cert.pem
CAPEM=organizations/peerOrganizations/sro.example.com/ca/ca.sro.example.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/sro.example.com/connection-sro.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/sro.example.com/connection-sro.yaml

ORG=rev
P0PORT=9051
CAPORT=9054
PEERPEM=organizations/peerOrganizations/rev.example.com/tlsca/tlsca.rev.example.com-cert.pem
CAPEM=organizations/peerOrganizations/rev.example.com/ca/ca.rev.example.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/rev.example.com/connection-rev.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/rev.example.com/connection-rev.yaml


ORG=bank
P0PORT=6051
CAPORT=6054
PEERPEM=organizations/peerOrganizations/bank.example.com/tlsca/tlsca.bank.example.com-cert.pem
CAPEM=organizations/peerOrganizations/bank.example.com/ca/ca.bank.example.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/bank.example.com/connection-bank.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/bank.example.com/connection-bank.yaml