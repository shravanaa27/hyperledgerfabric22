#!/bin/bash

function createSro() {
  echo "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/sro.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/sro.example.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-sro --tls.certfiles ${PWD}/organizations/fabric-ca/sro/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-sro.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-sro.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-sro.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-sro.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/sro.example.com/msp/config.yaml

  echo "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-sro --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/sro/tls-cert.pem
  { set +x; } 2>/dev/null

  echo "Registering user"
  set -x
  fabric-ca-client register --caname ca-sro --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/sro/tls-cert.pem
  { set +x; } 2>/dev/null

  echo "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-sro --id.name sroadmin --id.secret sroadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/sro/tls-cert.pem
  { set +x; } 2>/dev/null

  echo "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-sro -M ${PWD}/organizations/peerOrganizations/sro.example.com/peers/peer0.sro.example.com/msp --csr.hosts peer0.sro.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/sro/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/sro.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/sro.example.com/peers/peer0.sro.example.com/msp/config.yaml

  echo "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-sro -M ${PWD}/organizations/peerOrganizations/sro.example.com/peers/peer0.sro.example.com/tls --enrollment.profile tls --csr.hosts peer0.sro.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/sro/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/sro.example.com/peers/peer0.sro.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/sro.example.com/peers/peer0.sro.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/sro.example.com/peers/peer0.sro.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/sro.example.com/peers/peer0.sro.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/sro.example.com/peers/peer0.sro.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/sro.example.com/peers/peer0.sro.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/sro.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/sro.example.com/peers/peer0.sro.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/sro.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/sro.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/sro.example.com/peers/peer0.sro.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/sro.example.com/tlsca/tlsca.sro.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/sro.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/sro.example.com/peers/peer0.sro.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/sro.example.com/ca/ca.sro.example.com-cert.pem

  echo "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-sro -M ${PWD}/organizations/peerOrganizations/sro.example.com/users/User1@sro.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/sro/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/sro.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/sro.example.com/users/User1@sro.example.com/msp/config.yaml

  echo "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://sroadmin:sroadminpw@localhost:7054 --caname ca-sro -M ${PWD}/organizations/peerOrganizations/sro.example.com/users/Admin@sro.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/sro/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/sro.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/sro.example.com/users/Admin@sro.example.com/msp/config.yaml
}

function createRev() {
  echo "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/rev.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/rev.example.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-rev --tls.certfiles ${PWD}/organizations/fabric-ca/rev/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-rev.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-rev.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-rev.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-rev.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/rev.example.com/msp/config.yaml

  echo "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-rev --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/rev/tls-cert.pem
  { set +x; } 2>/dev/null

  echo "Registering user"
  set -x
  fabric-ca-client register --caname ca-rev --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/rev/tls-cert.pem
  { set +x; } 2>/dev/null

  echo "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-rev --id.name revadmin --id.secret revadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/rev/tls-cert.pem
  { set +x; } 2>/dev/null

  echo "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-rev -M ${PWD}/organizations/peerOrganizations/rev.example.com/peers/peer0.rev.example.com/msp --csr.hosts peer0.rev.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/rev/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/rev.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/rev.example.com/peers/peer0.rev.example.com/msp/config.yaml

  echo "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-rev -M ${PWD}/organizations/peerOrganizations/rev.example.com/peers/peer0.rev.example.com/tls --enrollment.profile tls --csr.hosts peer0.rev.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/rev/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/rev.example.com/peers/peer0.rev.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/rev.example.com/peers/peer0.rev.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/rev.example.com/peers/peer0.rev.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/rev.example.com/peers/peer0.rev.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/rev.example.com/peers/peer0.rev.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/rev.example.com/peers/peer0.rev.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/rev.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/rev.example.com/peers/peer0.rev.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/rev.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/rev.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/rev.example.com/peers/peer0.rev.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/rev.example.com/tlsca/tlsca.rev.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/rev.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/rev.example.com/peers/peer0.rev.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/rev.example.com/ca/ca.rev.example.com-cert.pem

  echo "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-rev -M ${PWD}/organizations/peerOrganizations/rev.example.com/users/User1@rev.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/rev/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/rev.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/rev.example.com/users/User1@rev.example.com/msp/config.yaml

  echo "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://revadmin:revadminpw@localhost:8054 --caname ca-rev -M ${PWD}/organizations/peerOrganizations/rev.example.com/users/Admin@rev.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/rev/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/rev.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/rev.example.com/users/Admin@rev.example.com/msp/config.yaml
}


function createBank() {
  echo "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/bank.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/bank.example.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:6054 --caname ca-bank --tls.certfiles ${PWD}/organizations/fabric-ca/bank/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-6054-ca-bank.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-6054-ca-bank.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-6054-ca-bank.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-6054-ca-bank.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/bank.example.com/msp/config.yaml

  echo "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-bank --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/bank/tls-cert.pem
  { set +x; } 2>/dev/null

  echo "Registering user"
  set -x
  fabric-ca-client register --caname ca-bank --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/bank/tls-cert.pem
  { set +x; } 2>/dev/null

  echo "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-bank --id.name bankadmin --id.secret bankadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/bank/tls-cert.pem
  { set +x; } 2>/dev/null

  echo "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:6054 --caname ca-bank -M ${PWD}/organizations/peerOrganizations/bank.example.com/peers/peer0.bank.example.com/msp --csr.hosts peer0.bank.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/bank/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/bank.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/bank.example.com/peers/peer0.bank.example.com/msp/config.yaml

  echo "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:6054 --caname ca-bank -M ${PWD}/organizations/peerOrganizations/bank.example.com/peers/peer0.bank.example.com/tls --enrollment.profile tls --csr.hosts peer0.bank.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/bank/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/bank.example.com/peers/peer0.bank.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/bank.example.com/peers/peer0.bank.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/bank.example.com/peers/peer0.bank.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/bank.example.com/peers/peer0.bank.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/bank.example.com/peers/peer0.bank.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/bank.example.com/peers/peer0.bank.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/bank.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/bank.example.com/peers/peer0.bank.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/bank.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/bank.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/bank.example.com/peers/peer0.bank.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/bank.example.com/tlsca/tlsca.bank.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/bank.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/bank.example.com/peers/peer0.bank.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/bank.example.com/ca/ca.bank.example.com-cert.pem

  echo "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:6054 --caname ca-bank -M ${PWD}/organizations/peerOrganizations/bank.example.com/users/User1@bank.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/bank/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/bank.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/bank.example.com/users/User1@bank.example.com/msp/config.yaml

  echo "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://bankadmin:bankadminpw@localhost:6054 --caname ca-bank -M ${PWD}/organizations/peerOrganizations/bank.example.com/users/Admin@bank.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/bank/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/bank.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/bank.example.com/users/Admin@bank.example.com/msp/config.yaml
}


function createOrderer() {
  echo "Enrolling the CA admin"
  mkdir -p organizations/ordererOrganizations/example.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/example.com

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml

  echo "Registering orderer"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  echo "Registering the orderer admin"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  echo "Generating the orderer msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/config.yaml

  echo "Generating the orderer-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls --enrollment.profile tls --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  mkdir -p ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  echo "Generating the admin msp"
  set -x
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp/config.yaml
}

createSro
createRev
createBank
createOrderer
