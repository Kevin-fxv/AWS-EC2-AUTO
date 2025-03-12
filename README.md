# CREACIÓN AUTOMATICA DE INSTANCIA EC2 CON CLOUDSHELL DE AWS


Este documento describe los pasos para crear una instancia EC2 en AWS de manera automatizada utilizando CloudShell y un script en Bash.

### 1. Acceder a Cloudshell en AWS
- Dirígete a la consola de AWS.
- En la página principal, abre una ventana de CloudShell.

### 2. Crear y Configurar el Script
- En CloudShell, crea el archivo launch_EC2.sh utilizando el siguiente comando:
  
  `nano launch_EC2.sh`

- Copia y pega el script proporcionado en el repositorio.
- Guarda los cambios y sal del editor (CTRL + X, luego Y y Enter).
- Asigna permisos de ejecución al script:

  `chmod +x launch_EC2.sh`

### 3. Ejecutar el Script
- Ejecuta el script con el siguiente comando para registrar la salida en un archivo de log:

  `./launch_EC2.sh | tee Ejecucion.log`

- Una vez finalizada la ejecución, se mostrará la IP pública de la instancia creada.
- También puedes verificar la instancia en la consola de AWS en la sección EC2 > Instancias.

### 4. Verificación de Archivos en CloudShell
- En CloudShell, verifica que se hayan generado la clave .pem y el archivo de registro ejecutando:
  
   `ls`

### 5. Descarga de la Clave .pem
- En CloudShell, en la parte superior derecha, haz clic en Acciones > Descargar Archivo.
- Especifica la ruta del archivo de la clave, por ejemplo:

  `/home/cloudshell-user/SERVER_AUTO_CLOUDSHELL.pem`

- Descarga y guarda el archivo en tu computadora.

### 6. Obtener el Usuario Predeterminado de la AMI
- Ejecuta el siguiente comando en CloudShell para obtener la ID de la AMI usada:

  `aws ec2 describe-instances --instance-ids i-xxxxxxxxxxxxxxxxx --query 'Reservations[*].Instances[*].ImageId'`

  _(Reemplaza i-xxxxxxxxxxxxxxxxx con el ID de tu instancia)._
- Luego, ejecuta:

  `aws ec2 describe-images --image-ids ami-xxxxxxxxxxxxxxxxx --query 'Images[*].[Name,Description]'`

  _(Reemplaza ami-xxxxxxxxxxxxxxxxx con la ID de la AMI obtenida anteriormente)._

### 7. Usuarios Predeterminados para Diferentes AMIs

| Sistema Operativo | Usuario Predeterminado |
|-------------------|------------------------|
| Amazon Linux      | ec2-user               |
| Ubuntu            | ubuntu                 |
| Debian            | admin o root           |
| Red Hat           | ec2-user o root        |
| CentOS            | centos                 |
| SUSE              | ec2-user o root        |
| Windows           | Administrator          |

### 8. Conectarse a la Instancia por SSH
- Abre una terminal en tu computadora y ubícate en la carpeta donde descargaste la clave .pem.
- Ejecuta el siguiente comando:

  `ssh -i SERVER_AUTO_CLOUDSHELL.pem usuario@IP_PUBLICA`

_(Sustituye "usuario" por el usuario predeterminado según la tabla anterior e "IP_PUBLICA" por la IP de la instancia creada)._
- Si todo está correcto, habrás ingresado a tu instancia EC2 exitosamente. 🎉


__Resumen:__

__Con estos pasos, hemos logrado desplegar una instancia EC2 de manera automatizada utilizando CloudShell, generar una clave de acceso, descargarla en nuestra computadora y conectarnos por SSH.__
