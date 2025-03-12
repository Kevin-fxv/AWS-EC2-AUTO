#!/bin/bash
# Script para lanzar una instancia EC2 desde AWS CloudShell

# Parámetros de configuración
AMI_ID="ami-04b4f1a9cf54c11d0"  # AMI de Amazon Linux (puede cambiar según la región y necesidad)
INSTANCE_TYPE="t2.micro"
KEY_NAME="SERVER_AUTO_CLOUDSHELL"  # Nombre de la clave SSH
SECURITY_GROUP_NAME="GS_CLOUDSHELL"  # Nombre del grupo de seguridad

# Crear la clave SSH si no existe
KEY_EXISTS=$(aws ec2 describe-key-pairs --key-names "$KEY_NAME" 2>/dev/null)
if [ -z "$KEY_EXISTS" ]; then
    echo "La clave $KEY_NAME no existe. Creándola..."
    aws ec2 create-key-pair --key-name "$KEY_NAME" --query 'KeyMaterial' --output text > ${KEY_NAME}.pem
    chmod 400 ${KEY_NAME}.pem
    echo "Clave creada y guardada en ${KEY_NAME}.pem"
else
    echo "La clave $KEY_NAME ya existe."
fi

# Verificar si el grupo de seguridad ya existe
SECURITY_GROUP_ID=$(aws ec2 describe-security-groups --group-names "$SECURITY_GROUP_NAME" --query 'SecurityGroups[0].GroupId' --output text 2>/dev/null)
if [ -z "$SECURITY_GROUP_ID" ]; then
    echo "El grupo de seguridad $SECURITY_GROUP_NAME no existe. Creándolo..."
    SECURITY_GROUP_ID=$(aws ec2 create-security-group --group-name "$SECURITY_GROUP_NAME" --description "Grupo de seguridad para CloudShell" --query 'GroupId' --output text)
    echo "Grupo de seguridad creado: $SECURITY_GROUP_ID"
else
    echo "El grupo de seguridad $SECURITY_GROUP_NAME ya existe con ID: $SECURITY_GROUP_ID"
fi

# Autorizar el ingreso para SSH (puerto 22)
aws ec2 authorize-security-group-ingress --group-id "$SECURITY_GROUP_ID" --protocol tcp --port 22 --cidr 0.0.0.0/0 2>/dev/null

# Lanzar la instancia EC2
INSTANCE_ID=$(aws ec2 run-instances \
    --image-id $AMI_ID \
    --count 1 \
    --instance-type $INSTANCE_TYPE \
    --key-name $KEY_NAME \
    --security-group-ids $SECURITY_GROUP_ID \
    --query 'Instances[0].InstanceId' \
    --output text)

echo "Instancia EC2 creada con ID: $INSTANCE_ID"

# Esperar a que la instancia esté operativa
echo "Esperando a que la instancia esté operativa..."
aws ec2 wait instance-running --instance-ids $INSTANCE_ID

# Obtener la IP pública
PUBLIC_IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)

echo "✅ Instancia EC2 lanzada exitosamente."
echo "🌎 IP Pública: $PUBLIC_IP"
