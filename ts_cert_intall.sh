#!/bin/bash

ROOTCA_CERT="./cert/OISTE WISeKey Global Root GB CA.pem"

ROOTCA_ALIAS1=oiste_wisekey_global_root_gb_ca
ROOTCA_ALIAS2=oistewisekeyglobalrootgbca
CACERTS_PASSWORD=changeit

CACERTS_OPTION="-cacerts"
JAVA_CACERTS=

# For java version 1.8 and below
#   -cacerts option is not supported.
function CheckCacertsOption()
{
    local JAVA_VERSION=$(java -version 2>&1 | grep version | awk -F '"' '{print $2}')
    local JAVA_VERSION_FIRST=$(echo -n $JAVA_VERSION |awk -F '.' '{print $1}')
    local JAVA_VERSION_SECOND=$(echo -n $JAVA_VERSION |awk -F '.' '{print $2}')

    if [ $JAVA_VERSION_FIRST -eq 1 ];then
        if [ $JAVA_VERSION_SECOND -le 8 ];then
            SetJavaCerts
            CACERTS_OPTION="-keystore $JAVA_CACERTS"
        fi
    fi
}

# GetJavaHome
function GetJavaHome()
{
    if [ ! -n "$JAVA_HOME" ]; then
        JAVA_HOME=`readlink -f $(which java) | sed "s:bin/java::"`
    fi
    echo $JAVA_HOME
}

# Java Cacerts path
function SetJavaCerts()
{
    local HOME

    if [ -n "$JRE_HOME" ]; then
        HOME=$JRE_HOME
    else
        HOME=$(GetJavaHome)
    fi

    if [ "${HOME: -1}" == "/" ]; then
        local length=${#HOME}
        local endindex=$(expr $length - 1)
        HOME=${HOME:0:$endindex}
    fi

    JAVA_CACERTS="${HOME}/lib/security/cacerts"
    if [ ! -f "$JAVA_CACERTS" ]; then
        JAVA_CACERTS="${HOME}/jre/lib/security/cacerts"
    fi

    if [ ! -f "$JAVA_CACERTS" ]; then
        echo "Not found Java Certs"
        exit;
    fi

    echo "Java Certs : $JAVA_CACERTS"
}

# Check Root Certificate
function IsExistRootCA()
{
    EXIST_ROOT=`keytool -list $CACERTS_OPTION -storepass $CACERTS_PASSWORD |grep $ROOTCA_ALIAS1`
    if [[ -z "$EXIST_ROOT" ]];then
        EXIST_ROOT=`keytool -list $CACERTS_OPTION -storepass $CACERTS_PASSWORD |grep $ROOTCA_ALIAS2`
        if [[ -z "$EXIST_ROOT" ]];then
            return 0;
        fi
    fi
    echo Already Included RootCA : $EXIST_ROOT
    return 1;
}

# Import RootCA Certificate
function ImportRootCACertificate()
{
    Result=`keytool -import $CACERTS_OPTION -noprompt -file "$ROOTCA_CERT" -alias $ROOTCA_ALIAS1 -storepass $CACERTS_PASSWORD`
    if [[ "$Result" =~ error ]];then
        echo $Result
    else
        echo Import RootCA : $ROOTCA_ALIAS1
    fi
}

CheckCacertsOption

IsExistRootCA

if [ $? -eq 0 ]; then
    ImportRootCACertificate
fi

